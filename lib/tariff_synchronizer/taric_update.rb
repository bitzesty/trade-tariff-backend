require "tariff_synchronizer/base_update"
require "tariff_synchronizer/taric_update_downloader"

module TariffSynchronizer
  class TaricUpdate < BaseUpdate
    class << self
      def download(date)
        TaricUpdateDownloader.new(date).perform
      end

      def update_type
        :taric
      end
    end

    def import!
      instrument("apply_taric.tariff_synchronizer", filename: filename) do
        TaricImporter.new(file_path, issue_date).import
        update_file_size
        mark_as_applied
      end
    end

    private

    def update_file_size
      update(filesize: File.size(file_path))
    end

    def self.validate_file!(xml_string)
      Ox.parse(xml_string)
    rescue Ox::ParseError => e
      raise InvalidContents.new(e.message, e)
    end
  end
end
