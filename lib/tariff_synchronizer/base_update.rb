module TariffSynchronizer
  class BaseUpdate < Sequel::Model(:tariff_updates)
    include FileService

    delegate :instrument, to: ActiveSupport::Notifications

    set_dataset db[:tariff_updates]

    plugin :timestamps
    plugin :single_table_inheritance, :update_type
    plugin :validation_class_methods

    class InvalidArgument < StandardError; end

    APPLIED_STATE = 'A'
    PENDING_STATE = 'P'
    FAILED_STATE  = 'F'
    MISSING_STATE = 'M'

    cattr_accessor :update_priority

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

      def last_pending
        pending.order(:issue_date).limit(1)
      end

      def descending
        order(Sequel.desc(:issue_date))
      end

      def latest_applied_of_both_kinds
        descending.from_self.group(:update_type).applied
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
      update(state: APPLIED_STATE, applied_at: Time.now )
    end

    def mark_as_failed
      update(state: FAILED_STATE)
    end

    def mark_as_pending
      update(state: PENDING_STATE)
    end

    def file_path
      File.join(TariffSynchronizer.root_path, self.class.update_type.to_s, filename)
    end

    def file_exists?
      # Check if file exists and if it doesn't try redownloading it.
      # This may be necessary when tariff runs in multiserver environment
      # where one server downloads updates and another server tries to apply it
      File.exists?(file_path) || (
        instrument("not_found_on_file_system.tariff_synchronizer", path: file_path)
        self.class.download(issue_date) || file_exists?
      )
    end

    def apply
      # Track latest SQL queries in a ring buffer and with error
      # email in case it happens
      # Based on http://goo.gl/vpTFyT (SequelRails LogSubscriber)
      @database_queries = RingBuffer.new(10)

      ActiveSupport::Notifications.subscribe /sql\.sequel/ do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)

        binds = unless event.payload.fetch(:binds, []).blank?
          event.payload[:binds].map { |column, value|
            [column.name, value]
          }.inspect
        end

        @database_queries.push(
          "(%{class_name}) %{sql} %{binds}" % {
            class_name: event.payload[:name],
            sql: event.payload[:sql].squeeze(' '),
            binds: binds
          }
        )
      end
    end

    class << self
      delegate :instrument, to: ActiveSupport::Notifications

      def sync
        (pending_from..Date.today).each { |date| download(date) }

        notify_about_missing_updates if self.order(Sequel.desc(:issue_date)).last(TariffSynchronizer.warning_day_count).all?(&:missing?)
      end

      def update_file_exists?(filename)
        dataset.where(filename: filename).present?
      end

      def update_type
        raise "Update Type should be specified in inheriting class"
      end

      private

      def create_entry(date, response, file_name)
        if response.success? && response.content_present?
          create_update_entry(date, PENDING_STATE, file_name, response.content.size)
          write_update_file(date, response, file_name)
        elsif response.success? && !response.content_present?
          create_update_entry(date, FAILED_STATE, file_name)
          instrument("blank_update.tariff_synchronizer", date: date, url: response.url)
        elsif response.retry_count_exceeded?
          create_update_entry(date, FAILED_STATE, file_name)
          instrument("retry_exceeded.tariff_synchronizer", date: date, url: response.url)
        elsif response.not_found?
          if date < Date.today
            create_update_entry(date, MISSING_STATE, missing_update_name_for(date))
            instrument("not_found.tariff_synchronizer", date: date, url: response.url)
          end
        end
      end

      def write_update_file(date, response, file_name)
        update_path = update_path(date, file_name)

        instrument("update_written.tariff_synchronizer", date: date,
          path: update_path, size: response.content.size) do
            write_file(update_path, response.content)
          end
      end

      def missing_update_name_for(date)
        "#{date}_#{update_type}"
      end

      def create_update_entry(date, state, file_name, filesize = nil)
        find_or_create(
          filename: file_name,
          filesize: filesize,
          update_type: self.name,
          issue_date: date
        ).update(state: state)
      end

      def update_path(date, file_name)
        File.join(TariffSynchronizer.root_path, update_type.to_s, file_name)
      end

      def pending_from
        if last_download = dataset.order(Sequel.desc(:issue_date)).first
          last_download.issue_date
        else
         TariffSynchronizer.initial_update_for(update_type)
        end
      end

      def parse_file_path(file_path)
        filename = Pathname.new(file_path).basename.to_s
        filename.match(/^(\d{4}-\d{2}-\d{2})_(.*)$/)[1,2]
      end

      def notify_about_missing_updates
        instrument("missing_updates.tariff_synchronizer",
                   update_type: update_type,
                   count: TariffSynchronizer.warning_day_count)
      end
    end
  end
end
