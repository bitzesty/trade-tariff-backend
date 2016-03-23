module TariffSynchronizer
  class BaseUpdate < Sequel::Model(:tariff_updates)
    include FileService

    delegate :instrument, to: ActiveSupport::Notifications

    one_to_many :conformance_errors, class: TariffUpdateConformanceError, key: :tariff_update_filename

    plugin :timestamps
    plugin :single_table_inheritance, :update_type
    plugin :validation_class_methods

    class InvalidArgument < StandardError; end
    class InvalidContents < StandardError
      attr_reader :original

      def initialize(msg, original)
        @original = original
        super(msg)
      end
    end

    APPLIED_STATE = "A".freeze
    PENDING_STATE = "P".freeze
    FAILED_STATE  = "F".freeze
    MISSING_STATE = "M".freeze

    self.unrestrict_primary_key

    validates do
      presence_of :filename, :issue_date
    end

    dataset_module do
      def applied
        filter(state: APPLIED_STATE)
      end

      def pending
        where(state: PENDING_STATE)
      end

      def pending_at(day)
        where(issue_date: day, state: PENDING_STATE)
      end

      def missing
        where(state: MISSING_STATE)
      end

      def with_issue_date(date)
        where(issue_date: date)
      end

      def failed
        where(state: FAILED_STATE)
      end

      def pending_or_failed
        where(state: [PENDING_STATE, FAILED_STATE])
      end

      def applied_or_failed
        where(state: [APPLIED_STATE, FAILED_STATE])
      end

      def last_pending
        pending.order(:issue_date).first
      end

      def descending
        order(Sequel.desc(:issue_date))
      end

      def latest_applied_of_both_kinds
        distinct(:update_type).select(Sequel.expr(:tariff_updates).*).descending.applied.order_prepend(:update_type)
      end
    end

    def applied?
      state == APPLIED_STATE
    end

    def pending?
      state == PENDING_STATE
    end

    def missing?
      state == MISSING_STATE
    end

    def failed?
      state == FAILED_STATE
    end

    def mark_as_applied
      update(state: APPLIED_STATE, applied_at: Time.now, last_error: nil, last_error_at: nil, exception_backtrace: nil, exception_class: nil)
    end

    def update_file_size(file_path)
      update(filesize: File.size(file_path))
    end

    def mark_as_failed
      update(state: FAILED_STATE)
    end

    def mark_as_pending
      update(state: PENDING_STATE)
    end

    def clear_applied_at
      update(applied_at: nil)
    end

    def file_path
      File.join(TariffSynchronizer.root_path, self.class.update_type.to_s, filename)
    end

    def file_exists?
      # Check if file exists and if it doesn't try redownloading it.
      # This may be necessary when tariff runs in multiserver environment
      # where one server downloads updates and another server tries to apply it
      File.exist?(file_path) || (
        instrument("not_found_on_file_system.tariff_synchronizer", path: file_path)
        self.class.download(issue_date) || file_exists?
      )
    end

    def import!
      raise NotImplementedError
    end

    def apply
      # Track latest SQL queries in a ring buffer and with error
      # email in case it happens
      # Based on http://goo.gl/vpTFyT (SequelRails LogSubscriber)
      @database_queries = RingBuffer.new(10)

      sql_subscriber = ActiveSupport::Notifications.subscribe(/sql\.sequel/) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)

        binds = unless event.payload.fetch(:binds, []).blank?
                  event.payload[:binds].map do |column, value|
                    [column.name, value]
                  end.inspect
                end

        @database_queries.push(
          format("(%{class_name}) %{sql} %{binds}",
            class_name: event.payload[:name],
            sql: event.payload[:sql].squeeze(" "),
            binds: binds
          )
        )
      end

      # Subscribe to conformance errors and save them to DB
      conformance_errors_subscriber = ActiveSupport::Notifications.subscribe(/conformance_error/) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        record = event.payload[:record]
        TariffUpdateConformanceError.create(
          base_update: self,
          model_name: record.class.to_s,
          model_primary_key: record.pk,
          model_values: record.values,
          model_conformance_errors: record.conformance_errors
        )
      end

      if file_exists?

        Sequel::Model.db.transaction(reraise: true) do
          # If a error is raised during import, the transaction is roll-backed
          # we then run this block afterwards to mark the update as failed
          Sequel::Model.db.after_rollback { mark_as_failed }

          import!
        end
      end
    rescue => e
      e = e.original if e.respond_to?(:original) && e.original
      update(exception_class: e.class.to_s + ": " + e.message.to_s,
             exception_backtrace: e.backtrace.join("\n"),
             exception_queries: @database_queries.join("\n"))

      instrument(
        "failed_update.tariff_synchronizer",
        exception: e, update: self, database_queries: @database_queries
      )
      raise Sequel::Rollback
    ensure
      ActiveSupport::Notifications.unsubscribe(sql_subscriber)
      ActiveSupport::Notifications.unsubscribe(conformance_errors_subscriber)
    end

    class << self
      delegate :instrument, to: ActiveSupport::Notifications

      def sync
        (pending_from..Date.current).each { |date| download(date) }
        notify_about_missing_updates if last_updates_are_missing?
      end

      def perform_download(local_file_name, tariff_url, date)
        local_file_path = get_local_file_path(local_file_name)

        if File.exists?(local_file_path)
          if update = find(filename: local_file_name, update_type: self.name, issue_date: date)
            update.update(filesize: File.read(local_file_path).size)
          else
            create_update_entry(
              date,
              BaseUpdate::PENDING_STATE,
              local_file_name,
              File.read(local_file_path).size
            )
          end
          instrument("created_tariff.tariff_synchronizer", date: date, filename: local_file_name, type: update_type)
        else
          instrument("download_tariff.tariff_synchronizer", date: date, url: tariff_url, filename: local_file_name, type: update_type) do
            download_content(tariff_url).tap do |response|
              create_entry(date, response, local_file_name)
            end
          end
        end
      end

      def save_entry(date, state, filename, type, filesize = nil)
        type = "TariffSynchronizer::#{type.to_s.classify}Update"

        if state == :failed
          state = FAILED_STATE
        elsif state == :pending
          state = PENDING_STATE
        end

        find_or_create(filename: filename, update_type: type, issue_date: date)
          .update(state: state, filesize: filesize)
      end

      def update_file_exists?(filename)
        dataset.where(filename: filename).present?
      end

      def update_type
        raise "Update Type should be specified in inheriting class"
      end

      private

      def get_local_file_path(local_file_name)
        File.join(TariffSynchronizer.root_path, update_type.to_s, local_file_name)
      end

      def create_entry(date, response, file_name)
        if response.success? && response.content_present?
          validate_and_create_update(date, response, file_name)
        elsif response.success? && !response.content_present?
          create_update_entry(date, FAILED_STATE, file_name)
          instrument("blank_update.tariff_synchronizer", date: date, url: response.url)
        elsif response.retry_count_exceeded?
          create_update_entry(date, FAILED_STATE, file_name)
          instrument("retry_exceeded.tariff_synchronizer", date: date, url: response.url)
        elsif response.not_found?
          if date < Date.current
            create_update_entry(date, MISSING_STATE, missing_update_name_for(date))
            instrument("not_found.tariff_synchronizer", date: date, url: response.url)
          end
        end
      end

      def validate_and_create_update(date, response, file_name)
        begin
          validate_file!(response)
        rescue InvalidContents => e
          instrument("invalid_contents.tariff_synchronizer", date: date, url: response.url)
          exception = e.original
          create_update_entry(date, FAILED_STATE, file_name).tap do |entry|
            entry.update(
              exception_class: "#{exception.class}: #{exception.message}",
              exception_backtrace: exception.backtrace.try(:join, "\n")
            )
          end
        else
          # file is valid
          create_update_entry(date, PENDING_STATE, file_name, response.content.size)
          write_update_file(date, response, file_name)
        end
      end

      def write_update_file(date, response, file_name)
        update_path = update_path(file_name)

        instrument("update_written.tariff_synchronizer", date: date, path: update_path, size: response.content.size) do
          write_file(update_path, response.content)
        end
      end

      def missing_update_name_for(date)
        "#{date}_#{update_type}"
      end

      def create_update_entry(date, state, file_name, filesize = nil)
        find_or_create(
          filename: file_name,
          update_type: self.name,
          issue_date: date
        ).update(state: state, filesize: filesize)
      end

      def update_path(file_name)
        File.join(TariffSynchronizer.root_path, update_type.to_s, file_name)
      end

      def pending_from
        if last_download = (last_pending || descending.first)
          last_download.issue_date
        else
          TariffSynchronizer.initial_update_date_for(update_type)
        end
      end

      def parse_file_path(file_path)
        filename = Pathname.new(file_path).basename.to_s
        filename.match(/^(\d{4}-\d{2}-\d{2})_(.*)$/)[1,2]
      end

      def last_updates_are_missing?
        order(Sequel.desc(:issue_date)).last(TariffSynchronizer.warning_day_count).all?(&:missing?)
      end

      def notify_about_missing_updates
        instrument("missing_updates.tariff_synchronizer",
                   update_type: update_type,
                   count: TariffSynchronizer.warning_day_count)
      end
    end
  end
end
