require 'tariff_synchronizer/taric_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class TaricArchive < TaricUpdate
    class << self
      def download(date)
        begin
          super
        rescue
          ActiveSupport::Notifications.instrument("not_found.tariff_synchronizer", date: date,
                                                                                     url: taric_query_url_for(date))
        end
      end

      def exists_for?(date)
        # Not sure we can check for existing content - sadpanda being a bad HTTP citizen.
        # Reason being, TARIC can have multiple update files for a given date; we can't
        # predict the existence of the file.
        false
      end

      def pending_from
        if ENV["TARIC_START_DATE"].present?
          Date.strptime(ENV["TARIC_START_DATE"], "%Y-%m-%d")
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