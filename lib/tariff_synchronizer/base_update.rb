module TariffSynchronizer
  class BaseUpdate < Sequel::Model
    set_dataset db[:tariff_updates]

    plugin :timestamps

    class InvalidArgument < StandardError; end

    APPLIED_STATE = 'A'
    PENDING_STATE = 'P'
    FAILED_STATE = 'F'

    cattr_accessor :update_priority

    delegate :logger, to: TariffSynchronizer

    self.unrestrict_primary_key

    dataset_module do
      def applied
        filter(state: APPLIED_STATE)
      end

      def pending
        where(state: PENDING_STATE)
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
  end
end
