require "tariff_synchronizer/base_update"
require "tariff_synchronizer/file_service"
require "tariff_synchronizer/taric_file_name_generator"

module TariffSynchronizer
  class TaricUpdate < BaseUpdate
    class << self
      def download(date)
        generator = TaricFileNameGenerator.new(date)
        initial_url = generator.url

        instrument("get_taric_update_name.tariff_synchronizer", date: date, url: initial_url)
        response = download_content(initial_url)

        if response.present?
          generator.get_info_from_response(response.content).each do |update|
            TariffDownloader.new(update[:filename], update[:url], date, self).perform
          end
        elsif response.empty?
          create_record_for_empty_response(date, initial_url)
        elsif response.retry_count_exceeded?
          create_record_for_retries_exceeded(date, initial_url)
        elsif response.not_found?
          create_missing_record(date, initial_url)
        end
      end

      def update_type
        :taric
      end

      private

      def create_record_for_empty_response(date, initial_url)
        create_or_update(date, BaseUpdate::FAILED_STATE, missing_filename(date))
        instrument("blank_update.tariff_synchronizer", date: date, url: initial_url)
      end

      def create_record_for_retries_exceeded(date, initial_url)
        create_or_update(date, BaseUpdate::FAILED_STATE, missing_filename(date))
        instrument("retry_exceeded.tariff_synchronizer", date: date, url: initial_url)
      end

      def create_missing_record(date, initial_url)
        # Do not create missing record until we are sure until the next day
        return if date >= Date.current
        create_or_update(date, BaseUpdate::MISSING_STATE, missing_filename(date))
        instrument("not_found.tariff_synchronizer", date: date, url: initial_url)
      end

      def missing_filename(date)
        "#{date}_#{update_type}"
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
