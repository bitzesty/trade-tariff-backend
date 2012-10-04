require 'tariff_synchronizer/base_update'
require 'tariff_synchronizer/file_service'

module TariffSynchronizer
  class TaricUpdate < BaseUpdate
    set_dataset db[:tariff_updates].
                filter(update_type: 'TaricUpdate')

    self.update_priority = 2

    def self.download(date)
      if file_name = get_taric_path(date)
        taric_data_url = "#{TariffSynchronizer.host}/taric/#{file_name}"
        TariffSynchronizer.logger.info "Downloading Taric file for #{date} at: #{taric_data_url}"
        FileService.get_content(taric_data_url).tap{|contents|
          FileService.write_file(update_path(date, file_name), contents) if contents.present?
        }

        create(filename: "#{date}_#{file_name}",
               update_type: 'TaricUpdate',
               state: 'P',
               issue_date: date)
      else
        TariffSynchronizer.logger.error "No Taric file found for #{date}."
      end
    end

    def apply
      TariffImporter.new(file_path, TaricImporter).import

      mark_as_applied
      logger.info "Successfully applied Taric update: #{file_path}"
    end

    def self.update_type
      :taric
    end

    def self.file_name_for(date)
      "#{date}_TGB#{date.strftime("%y")}#{date.yday}.xml"
    end

    private

    def self.get_taric_path(date)
      date_query = Date.parse(date.to_s).strftime("%Y%m%d")
      taric_query_url = "#{TariffSynchronizer.host}/taric/TARIC3#{date_query}"
      TariffSynchronizer.logger.info "Checking for Taric file for #{date} at: #{taric_query_url}"
      FileService.get_content(taric_query_url).tap { |file_name|
        file_name.gsub!(/[^0-9a-zA-Z\.]/i, '') if file_name.present?
      }
    end
  end
end
