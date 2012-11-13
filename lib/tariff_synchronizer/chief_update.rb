require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    self.update_priority = 1

    class << self
      def download(date)
        ActiveSupport::Notifications.instrument("download_chief.tariff_synchronizer", date: date) do
          download_content(chief_update_url_for(date)).tap { |response|
            create_entry(date, response)
          }
        end
      end

      def update_type
        :chief
      end

      def rebuild
        Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'chief', '*.txt')].each do |file_path|
          date, file_name = parse_file_path(file_path)

          create_update_entry(Date.parse(date), BaseUpdate::PENDING_STATE)
        end
      end

      def file_name_for(date)
        "#{date}_#{chief_file_name_for(date)}"
      end
    end

    def apply
      ActiveSupport::Notifications.instrument("apply_chief.tariff_synchronizer", filename: filename) do
        TariffImporter.new(file_path, ChiefImporter).import

        mark_as_applied
      end
    end

    private

    def self.chief_file_name_for(date)
      "KBT009(#{date.strftime("%y")}#{date.yday}).txt"
    end

    def self.chief_update_url_for(date)
      TariffSynchronizer.chief_update_url_template % { host: TariffSynchronizer.host,
                                                       file_name: chief_file_name_for(date)}
    end
  end
end
