require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class ChiefUpdate < BaseUpdate
    self.update_priority = 1

    def self.download(date)
      file_name = "KBT009(#{date.strftime("%y")}#{date.yday}).txt"
      chief_url = "#{TariffSynchronizer.host}/taric/#{file_name}"
      TariffSynchronizer.logger.info "Downloading CHIEF file for #{date} at: #{chief_url}"
      FileService.get_content(chief_url).tap {|status, contents|
        create_update_entry(date, file_name, status, "ChiefUpdate") unless status == :not_found && date == Date.today

        write_update_file(date, file_name, contents) if status == :success
      }
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

    def self.rebuild
      Dir[File.join(Rails.root, TariffSynchronizer.root_path, 'chief', '*.txt')].each do |file_path|
        date, file_name = parse_file_path(file_path)

        create_update_entry(date, file_name, :success, "ChiefUpdate")
      end
    end
  end
end
