module TariffSynchronizer
  class BaseUpdate < Sequel::Model
    include FileService

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
    end

    def mark_as_applied
      update(state: APPLIED_STATE)
    end

    def file_path
      File.join(TariffSynchronizer.root_path, self.class.update_type.to_s, filename)
    end

    def apply
      File.exists?(file_path) || ActiveSupport::Notifications.instrument("not_found_on_file_system.tariff_synchronizer", path: file_path)
    end

    class << self
      def sync
        unless pending_from == Date.today
          (pending_from..Date.today).each do |date|
            download(date) unless exists_for?(date)
          end
        end
      end

      def exists_for?(date)
        dataset.where(issue_date: date).any?
      end

      def update_type
        raise "Update Type should be specified in inheriting class"
      end

      private

      def create_entry(date, response)
        if response.success? && response.content_present?
          create_update_entry(date, PENDING_STATE)
          write_update_file(date, response.content)
        elsif response.success? && !response.content_present?
          create_update_entry(date, FAILED_STATE)
          ActiveSupport::Notifications.instrument("blank_update.tariff_synchronizer", date: date,
                                                                                      url: response.url)
        elsif response.retry_count_exceeded?
          create_update_entry(date, FAILED_STATE)
          ActiveSupport::Notifications.instrument("retry_exceeded.tariff_synchronizer", date: date,
                                                                                        url: response.url)
        elsif response.not_found?
          if date < Date.today
            create_update_entry(date, MISSING_STATE)
            ActiveSupport::Notifications.instrument("not_found.tariff_synchronizer", date: date,
                                                                                     url: response.url)
          end
        end
      end

      def write_update_file(date, contents)
        update_path = update_path(date, file_name_for(date))

        ActiveSupport::Notifications.instrument("update_written.tariff_synchronizer", date: date,
                                                                                      path: update_path,
                                                                                      size: contents.size) do
          write_file(update_path, contents)
        end
      end

      def create_update_entry(date, state)
        find_or_create(filename: file_name_for(date),
                       update_type: self.name,
                       issue_date: date).update(state: state)
      end

      def update_path(date, file_name)
        File.join(TariffSynchronizer.root_path, update_type.to_s, file_name)
      end

      def pending_from
        if last_download = dataset.order(:issue_date.desc).first
          last_download.issue_date
        else
         TariffSynchronizer.initial_update_for(update_type)
        end
      end

      def parse_file_path(file_path)
        filename = Pathname.new(file_path).basename.to_s
        filename.match(/^(\d{4}-\d{2}-\d{2})_(.*)$/)[1,2]
      end
    end
  end
end
