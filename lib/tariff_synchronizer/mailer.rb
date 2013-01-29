module TariffSynchronizer
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def exception(exception, update)
      @failed_file_path = update.file_path
      @exception = exception.original.presence || exception

      mail subject: "[error] Failed Trade Tariff update #{environment_indicator}"
    end

    def failures_reminder(file_names)
      @file_names = file_names

      mail subject: "[error] Update application failed: failed Trade Tariff updates present #{environment_indicator}"
    end

    def file_not_found_on_filesystem(path)
      @path = path

      mail subject: "[error] Update application failed: update file not found #{environment_indicator}"
    end

    def retry_exceeded(url, date)
      @url = url
      @date = date

      mail subject: "[warn] Update fetch failed: download retry count exceeded #{environment_indicator}"
    end

    def blank_update(url, date)
      @url = url
      @date = date

      mail subject: "[error] Update fetch failed: received blank update file #{environment_indicator}"
    end

    def file_write_error(path, reason)
      @path = path
      @reason = reason

      mail subject: "[error] Update fetch failed: cannot write update file to file system #{environment_indicator}"
    end

    def applied(update_names, count)
      @update_names = update_names
      @count = count

      mail subject: "[info] Tariff updates applied #{environment_indicator}"
    end

    def missing_updates(count, update_type)
      @count = count
      @update_type = update_type

      mail subject: "[warn] Missing #{count} #{update_type.upcase} updates in a row #{environment_indicator}"
    end
  end
end
