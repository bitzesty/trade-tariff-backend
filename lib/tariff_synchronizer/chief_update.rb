require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    set_dataset db[:tariff_updates].
                filter(update_type: 'ChiefUpdate')

    self.update_priority = 1

    def self.download(date)
      file_name = "KBT009(#{date.strftime("%y")}#{date.yday}).txt"
      file_url = "#{TariffSynchronizer.host}/taric/#{file_name}"
      TariffSynchronizer.logger.info "Downloading CHIEF file for #{date} at: #{file_url}"
      FileService.get_content(file_url).tap {|contents|
        FileService.write_file(update_path(date, file_name), contents) if contents.present?
      }

      create(filename: "#{date}_#{file_name}",
             update_type: 'ChiefUpdate',
             state: 'P',
             issue_date: date)
    end

    def self.file_name_for(date)
      "#{date}_KBT009(#{date.strftime("%y")}#{date.yday}).txt"
    end

    def apply
      TariffImporter.new(file_path, ChiefImporter).import

      mark_as_applied
      logger.info "Successfully applied CHIEF update: #{file_path}"
    end

    def self.update_type
      :chief
    end
  end
end
