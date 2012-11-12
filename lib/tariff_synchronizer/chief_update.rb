require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    self.update_priority = 1

    def self.download(date)
      ActiveSupport::Notifications.instrument("download_chief.tariff_synchronizer", date: date) do
        file_name = "KBT009(#{date.strftime("%y")}#{date.yday}).txt"
        chief_url = "#{TariffSynchronizer.host}/taric/#{file_name}"

        FileService.get_content(chief_url).tap {|status, contents|
          # TODO log not found
          create_update_entry(date, file_name, status, "ChiefUpdate") unless status == :not_found && date == Date.today

          write_update_file(date, file_name, contents) if status == :success
        }
      end
    end

    def self.file_name_for(date)
      "#{date}_KBT009(#{date.strftime("%y")}#{date.yday}).txt"
    end

    def apply
      ActiveSupport::Notifications.instrument("apply_chief.tariff_synchronizer", filename: filename) do
        TariffImporter.new(file_path, ChiefImporter).import

        mark_as_applied
      end
    end

    def self.update_type
      :chief
    end

    def self.rebuild
      Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'chief', '*.txt')].each do |file_path|
        date, file_name = parse_file_path(file_path)

        create_update_entry(date, file_name, :success, "ChiefUpdate")
      end
    end
  end
end
