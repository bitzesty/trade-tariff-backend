# Download pending updates for TARIC and CHIEF data
# Gets latest downloaded file present in (inbox/failbox/processed) and tries
# to download any further updates to current day.
# require "tariff_synchronizer/file_service"
module TariffSynchronizer
  class TariffDownloader
    include FileService

    delegate :instrument, :subscribe, to: ActiveSupport::Notifications

    attr_reader :filename, :url, :date, :update_klass

    def initialize(filename, url, date, update_klass)
      @filename = filename
      @url = url
      @date = date
      @update_klass = update_klass
    end

    def perform
      if file_downloaded?
        update_record
        instrument("created_tariff.tariff_synchronizer", date: date, filename: filename, type: update_klass.update_type)
      else
        instrument("download_tariff.tariff_synchronizer", date: date, url: url, filename: filename, type: update_klass.update_type) do
          response = TariffDownloader.download_content(url)
          create_entry(response)
        end
      end
    end

    private

    def update_record
      if update_object.present?
        update_object.update(filesize: filesize)
      else
        create_or_update(BaseUpdate::PENDING_STATE, filename, filesize)
      end
    end

    def file_downloaded?
      File.exist?(file_path)
    end

    def update_object
      update_klass.find(filename: filename, update_type: update_klass.name, issue_date: date)
    end

    def file_path
      File.join(TariffSynchronizer.root_path, update_klass.update_type.to_s, filename)
    end

    def filesize
      @filesize ||= File.read(file_path).size
    end

    def create_entry(response)
      if response.success? && response.content_present?
        validate_and_create_update(response)
      elsif response.success? && !response.content_present?
        create_record_for_empty_response(response)
      elsif response.retry_count_exceeded?
        create_record_for_retries_exceeded(response)
      elsif response.not_found?
        create_missing_record(response)
      end
    end

    def create_record_for_empty_response(response)
      create_or_update(BaseUpdate::FAILED_STATE, filename)
      instrument("blank_update.tariff_synchronizer", date: date, url: response.url)
    end

    def create_record_for_retries_exceeded(response)
      create_or_update(BaseUpdate::FAILED_STATE, filename)
      instrument("retry_exceeded.tariff_synchronizer", date: date, url: response.url)
    end

    def create_missing_record(response)
      # Do not create missing record until we are sure until the next day
      return if date >= Date.current

      create_or_update(BaseUpdate::MISSING_STATE, missing_update_name)
      instrument("not_found.tariff_synchronizer", date: date, url: response.url)
    end

    def validate_and_create_update(response)
      begin
        update_klass.validate_file!(response.content)
      rescue BaseUpdate::InvalidContents => e
        instrument("invalid_contents.tariff_synchronizer", date: date, url: response.url)
        exception = e.original
        create_or_update(BaseUpdate::FAILED_STATE, filename).tap do |entry|
          entry.update(
            exception_class: "#{exception.class}: #{exception.message}",
            exception_backtrace: exception.backtrace.try(:join, "\n")
          )
        end
      else
        # file is valid
        create_or_update(BaseUpdate::PENDING_STATE, filename, response.content.size)
        write_update_file(response)
      end
    end

    def create_or_update(state, file_name, file_size = nil)
      update_klass.find_or_create(
        filename: file_name,
        update_type: update_klass.name,
        issue_date: date
      ).update(state: state, filesize: file_size)
    end

    def write_update_file(response)
      instrument("update_written.tariff_synchronizer", date: date, path: update_path, size: response.content.size) do
        TariffDownloader.write_file(update_path, response.content)
      end
    end

    def update_path
      File.join(TariffSynchronizer.root_path, update_klass.update_type.to_s, filename)
    end

    def missing_update_name
      "#{date}_#{update_klass.update_type}"
    end
  end
end
