# Download pending updates for TARIC and CHIEF data
# Gets latest downloaded file present in (inbox/failbox/processed) and tries
# to download any further updates to current day.
# require "tariff_synchronizer/file_service"
module TariffSynchronizer
  class TariffDownloader
    include FileService

    delegate :instrument, :subscribe, to: ActiveSupport::Notifications

    attr_reader :local_file_name, :tariff_url, :date, :update_klass

    def initialize(local_file_name, tariff_url, date, update_klass)
      @local_file_name = local_file_name
      @tariff_url = tariff_url
      @date = date
      @update_klass = update_klass
    end

    def perform
      if File.exists?(local_file_path)
        if update = update_klass.find(filename: local_file_name, update_type: update_klass.name, issue_date: date)
          update.update(filesize: File.read(local_file_path).size)
        else
          create_or_update(
            date,
            BaseUpdate::PENDING_STATE,
            local_file_name,
            File.read(local_file_path).size
          )
        end
        instrument("created_tariff.tariff_synchronizer", date: date, filename: local_file_name, type: update_klass.update_type)
      else
        instrument("download_tariff.tariff_synchronizer", date: date, url: tariff_url, filename: local_file_name, type: update_klass.update_type) do
          TariffDownloader.download_content(tariff_url).tap do |response|
            create_entry(date, response, local_file_name)
          end
        end
      end
    end

    private

    def local_file_path
      File.join(TariffSynchronizer.root_path, update_klass.update_type.to_s, local_file_name)
    end

    def create_entry(date, response, file_name)
      if response.success? && response.content_present?
        validate_and_create_update(date, response, file_name)
      elsif response.success? && !response.content_present?
        create_or_update(date, BaseUpdate::FAILED_STATE, file_name)
        instrument("blank_update.tariff_synchronizer", date: date, url: response.url)
      elsif response.retry_count_exceeded?
        create_or_update(date, BaseUpdate::FAILED_STATE, file_name)
        instrument("retry_exceeded.tariff_synchronizer", date: date, url: response.url)
      elsif response.not_found?
        if date < Date.current
          create_or_update(date, BaseUpdate::MISSING_STATE, missing_update_name_for(date))
          instrument("not_found.tariff_synchronizer", date: date, url: response.url)
        end
      end
    end

    def create_or_update(date, state, file_name, filesize = nil)
      update_klass.find_or_create(
        filename: file_name,
        update_type: update_klass.name,
        issue_date: date
      ).update(state: state, filesize: filesize)
    end

    def validate_and_create_update(date, response, file_name)
      begin
        update_klass.validate_file!(response.content)
      rescue BaseUpdate::InvalidContents => e
        instrument("invalid_contents.tariff_synchronizer", date: date, url: response.url)
        exception = e.original
        create_or_update(date, BaseUpdate::FAILED_STATE, file_name).tap do |entry|
          entry.update(
            exception_class: "#{exception.class}: #{exception.message}",
            exception_backtrace: exception.backtrace.try(:join, "\n")
          )
        end
      else
        # file is valid
        create_or_update(date, BaseUpdate::PENDING_STATE, file_name, response.content.size)
        write_update_file(date, response, file_name)
      end
    end

    def write_update_file(date, response, file_name)
      update_path = update_path(file_name)

      instrument("update_written.tariff_synchronizer", date: date, path: update_path, size: response.content.size) do
        TariffDownloader.write_file(update_path, response.content)
      end
    end

    def update_path(file_name)
      File.join(TariffSynchronizer.root_path, update_klass.update_type.to_s, file_name)
    end

    def missing_update_name_for(date)
      "#{date}_#{update_klass.update_type}"
    end
  end
end
