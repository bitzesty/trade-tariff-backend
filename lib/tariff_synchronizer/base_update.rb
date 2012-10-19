module TariffSynchronizer
  class BaseUpdate < Sequel::Model
    set_dataset db[:tariff_updates]

    plugin :timestamps
    plugin :single_table_inheritance, :update_type
    plugin :validation_class_methods

    class InvalidArgument < StandardError; end

    APPLIED_STATE = 'A'
    PENDING_STATE = 'P'
    FAILED_STATE  = 'F'
    MISSING_STATE = 'M'
    STATE_MAP = {
      success: PENDING_STATE,
      not_found: MISSING_STATE,
      failed: FAILED_STATE
    }

    cattr_accessor :update_priority

    delegate :logger, to: TariffSynchronizer

    self.unrestrict_primary_key

    validates do
      presence_of :filename, :issue_date, :state
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

    def self.sync
      unless pending_from == Date.today
        (pending_from..Date.today).each do |date|
          download(date) unless exists_for?(date)
        end
      end
    end

    def self.exists_for?(date)
      dataset.where(issue_date: date).any?
    end

    def self.update_type
      raise "Update Type should be specified in inheriting class"
    end

    private

    def self.write_update_file(date, file_name, contents)
      update_path = update_path(date, file_name)

      if contents.present?
        FileService.write_file(update_path, contents)
      else
        TariffSynchronizer.logger.error "Could not write update file: #{file_name}. Nothing was downloaded."

        false
      end
    end

    def self.create_update_entry(date, file_name, state, update_type)
      update = find_or_create(filename: "#{date}_#{file_name}",
                              update_type: "TariffSynchronizer::#{update_type}",
                              issue_date: date)

      update.update(state: STATE_MAP[state])
    end

    def self.update_path(date, file_name)
      File.join(TariffSynchronizer.root_path, update_type.to_s, "#{date}_#{file_name}")
    end

    def self.pending_from
      if last_download = dataset.order(:issue_date.desc).first
        last_download.issue_date
      else
       TariffSynchronizer.initial_update_for(update_type)
      end
    end

    def self.parse_file_path(file_path)
      file_name = Pathname.new(file_path).basename.to_s
      file_name.match(/^(\d{4}-\d{2}-\d{2})_(.*)$/)[1,2]
    end
  end
end
