module TariffSynchronizer
  class Mailer < ActionMailer::Base
    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TariffSynchronizer.admin_email

    def exception(exception, update)
      @failed_file_path = update.file_path
      @exception = exception.original.presence || exception

      mail subject: '[error] Failed Trade Tariff update'
    end

    def failures_reminder(file_names)
      @file_names = file_names

      mail subject: '[error] Update application failed: failed Trade Tariff updates present'
    end

    def file_not_found_on_filesystem(path)
      @path = path

      mail subject: '[error] Update application failed: update file not found'
    end

    def retry_exceeded(url, date)
      @url = url
      @date = date

      mail subject: '[warn] Update fetch failed: download retry count exceeded'
    end

    def blank_update(url, date)
      @url = url
      @date = date

      mail subject: '[error] Update fetch failed: received blank update file'
    end

    def file_write_error(path, reason)
      @path = path
      @reason = reason

      mail subject: '[error] Update fetch failed: cannot write update file to file system'
    end

    def applied(count)
      @count = count

      mail subject: '[info] Tariff updates applied'
    end
  end
end
