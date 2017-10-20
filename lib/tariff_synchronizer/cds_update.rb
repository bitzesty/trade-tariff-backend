module TariffSynchronizer
  class CdsUpdate < BaseUpdate
    class << self
      def download(date)
        url = "some url to new xml file"
        filename = "some filename"

        # TODO:
        # get the url and filename depending on CDS api

        TariffDownloader.new(filename, url, date, self).perform
      end

      def update_type
        :cds
      end
    end

    def import!
      instrument("apply_cds.tariff_synchronizer", filename: filename) do
        CdsImporter.new(self).import
        mark_as_applied
      end
    end

    private

    def self.validate_file!(xml_string)
      Ox.parse(xml_string)
    rescue Ox::ParseError => e
      raise InvalidContents.new(e.message, e)
    end
  end
end
