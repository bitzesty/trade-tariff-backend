require "tariff_synchronizer/taric_file_name_generator"

module TariffSynchronizer
  # Download pending updates TARIC files
  class TaricUpdateDownloader
    include FileService

    delegate :instrument, :subscribe, to: ActiveSupport::Notifications

    attr_reader :date, :url

    def initialize(date)
      @generator = TaricFileNameGenerator.new(date)
      @date = date
      @url = @generator.url
    end

    def perform
      log_request_to_taric_update

      if response.present?
        create_records_for_successful_response
      elsif response.empty?
        create_record_for_empty_response
      elsif response.retry_count_exceeded?
        create_record_for_retries_exceeded
      elsif response.not_found?
        create_missing_record
      end
    end

    private

    def response
      @response ||= TaricUpdateDownloader.download_content(url)
    end

    def create_records_for_successful_response
      @generator.get_info_from_response(response.content).each do |update|
        TariffDownloader.new(update[:filename], update[:url], date, TariffSynchronizer::TaricUpdate).perform
      end
    end

    def create_record_for_empty_response
      update_or_create(BaseUpdate::FAILED_STATE, missing_filename)
      instrument("blank_update.tariff_synchronizer", date: date, url: url)
    end

    def create_record_for_retries_exceeded
      update_or_create(BaseUpdate::FAILED_STATE, missing_filename)
      instrument("retry_exceeded.tariff_synchronizer", date: date, url: url)
    end

    def create_missing_record
      # Do not create missing record until we are sure until the next day
      return if date >= Date.current
      update_or_create(BaseUpdate::MISSING_STATE, missing_filename)
      instrument("not_found.tariff_synchronizer", date: date, url: url)
    end

    def missing_filename
      "#{date}_taric"
    end

    def update_or_create(state, file_name)
      TariffSynchronizer::TaricUpdate.find_or_create(filename: file_name,
                                                     issue_date: date)
        .update(state: state)
    end

    def log_request_to_taric_update
      instrument("get_taric_update_name.tariff_synchronizer", date: date, url: url)
    end
  end
end
