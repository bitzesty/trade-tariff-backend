require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/download_service'

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    self.update_priority = 1

    def self.download(date)
      file_name = "KBT009(#{date.strftime("%y")}#{date.yday}).txt"
      chief_url = "#{TariffSynchronizer.host}/taric/#{file_name}"
      TariffSynchronizer.logger.info "Downloading CHIEF file for #{date} at: #{chief_url}"
      DownloadService.get_content(chief_url).tap {|contents|
        create_update_entry(date, file_name, contents, "ChiefUpdate") if contents.present?
      }
    end

    def self.file_name_for(date)
      "#{date}_KBT009(#{date.strftime("%y")}#{date.yday}).txt"
    end

    def apply
      TariffImporter.import(self, ChiefImporter)

      mark_as_applied
      logger.info "Successfully applied CHIEF update: #{filename}"
    end

    def self.update_type
      :chief
    end
  end
end
