module TariffSynchronizer
  # Download pending updates for TARIC and CHIEF data
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
      if file_already_downloaded?
        create_or_update_entry
      else
        download_and_create_entry
      end
    end

    private

    def create_or_update_entry
      if update_object.present?
        update_object.update(filesize: filesize)
      else
        create_or_update(filename, BaseUpdate::PENDING_STATE, filesize)
      end
      instrument("created_tariff.tariff_synchronizer", date: date, filename: filename, type: update_klass.update_type)
    end

    def download_and_create_entry
      instrument("download_tariff.tariff_synchronizer", date: date, url: url, filename: filename, type: update_klass.update_type) do
        create_entry TariffDownloader.download_content(url)
      end
    end

    def file_already_downloaded?
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
      if response.present?
        validate_and_create_update(response)
      elsif response.empty?
        create_record_for_empty_response(response)
      elsif response.retry_count_exceeded?
        create_record_for_retries_exceeded(response)
      elsif response.not_found?
        create_missing_record(response)
      end
    end

    def create_record_for_empty_response(response)
      create_or_update(filename, BaseUpdate::FAILED_STATE)
      instrument("blank_update.tariff_synchronizer", date: date, url: response.url)
    end

    def create_record_for_retries_exceeded(response)
      create_or_update(filename, BaseUpdate::FAILED_STATE)
      instrument("retry_exceeded.tariff_synchronizer", date: date, url: response.url)
    end

    def create_missing_record(response)
      # Do not create missing record until we are sure until the next day
      return if date >= Date.current

      create_or_update(missing_update_name, BaseUpdate::MISSING_STATE)
      instrument("not_found.tariff_synchronizer", date: date, url: response.url)
    end

    def validate_and_create_update(response)
      update_klass.validate_file!(response.content) # Validate response
      create_or_update(filename, BaseUpdate::PENDING_STATE, response.content.size)
      write_update_file(response)
    rescue BaseUpdate::InvalidContents => exception
      instrument("invalid_contents.tariff_synchronizer", date: date, url: response.url)
      create_or_update(filename, BaseUpdate::FAILED_STATE).tap do |entry|
        entry.update(
          exception_class: "#{exception.original.class}: #{exception.original.message}",
          exception_backtrace: exception.original.backtrace.try(:join, "\n")
        )
      end
    end

    def create_or_update(file_name, state, file_size = nil)
      update_klass.find_or_create(filename: file_name,
                                  update_type: update_klass.name,
                                  issue_date: date)
                                  .update(state: state, filesize: file_size)
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
    #
    # def logger(key, payload = {})
    #   ActiveSupport::Notifications.instrument("#{key}.tariff_synchronizer", payload)
    # end
  end
end
