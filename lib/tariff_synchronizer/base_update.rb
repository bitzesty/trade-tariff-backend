module TariffSynchronizer
  class BaseUpdate < Sequel::Model
    set_dataset db[:tariff_updates]

    plugin :timestamps
    plugin :single_table_inheritance, :update_type

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

    def self.create_update_entry(date, file_name, contents, update_type)
      if contents.size <= TariffSynchronizer.max_update_size
        create(filename: "#{date}_#{file_name}",
               update_type: "TariffSynchronizer::#{update_type}",
               state: 'P',
               issue_date: date,
               file: contents.to_s.to_sequel_blob) unless entry_exists_for?(date, file_name)
      else
        TariffSynchronizer.logger.error "#{date}_#{file_name} was greater than #{TariffSynchronizer.max_update_size} size. Please adjust the setting and retry."
      end
    end

    def self.pending_from
      if last_download = dataset.order(:issue_date.desc).first
        last_download.issue_date
      else
       TariffSynchronizer.initial_update_for(update_type)
      end
    end

    def self.entry_exists_for?(date, file_name)
      where(issue_date: date,
            filename: "#{date}_#{file_name}").any?
    end
  end
end
