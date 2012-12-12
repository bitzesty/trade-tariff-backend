require 'tariff_synchronizer/chief_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class ChiefArchive < ChiefUpdate
    class << self
      def download(date)
        begin
          super
        rescue
          ActiveSupport::Notifications.instrument("not_found.tariff_synchronizer", date: date,
                                                                                     url: chief_update_url_for(date))
        end
      end

      def exists_for?(date)
        # We can check the filesystem to see if we have a file locally (that is zero-length?)
        local_file = update_path(date, file_name_for(date))
        File.exists?(local_file) && File.stat(local_file).size != 0
      end

      def pending_from
        if ENV["CHIEF_START_DATE"].present?
          Date.strptime(ENV["CHIEF_START_DATE"], "%Y-%m-%d")
        else
          TariffSynchronizer.initial_update_for(update_type)
        end
      end

      def create_update_entry(date, state, file_name = file_name_for(date))
        # no-op
      end
    end
  end
end