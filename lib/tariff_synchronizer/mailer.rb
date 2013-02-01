require 'mailer_environment'

module TariffSynchronizer
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def exception(exception, update)
      @failed_file_path = update.file_path
      @exception = exception.original.presence || exception

      mail subject: "#{subject_prefix(:error)} Failed Trade Tariff update"
    end

    def failed_download(exception, url)
      @url = url
      @exception = exception

      mail subject: "#{subject_prefix(:error)} Trade Tariff download failure"
    end

    def failures_reminder(file_names)
      @file_names = file_names

      mail subject: "#{subject_prefix(:error)} Update application failed: failed Trade Tariff updates present"
    end

    def file_not_found_on_filesystem(path)
      @path = path

      mail subject: "#{subject_prefix(:error)} Update application failed: update file not found"
    end

    def retry_exceeded(url, date)
      @url = url
      @date = date

      mail subject: "#{subject_prefix(:warn)} Update fetch failed: download retry count exceeded"
    end

    def blank_update(url, date)
      @url = url
      @date = date

      mail subject: "#{subject_prefix(:error)} Update fetch failed: received blank update file"
    end

    def file_write_error(path, reason)
      @path = path
      @reason = reason

      mail subject: "#{subject_prefix(:error)} Update fetch failed: cannot write update file to file system"
    end

    def applied(update_names, count)
      @update_names = update_names
      @count = count

      mail subject: "#{subject_prefix(:info)} Tariff updates applied"
    end

    def missing_updates(count, update_type)
      @count = count
      @update_type = update_type

      mail subject: "#{subject_prefix(:warn)} Missing #{count} #{update_type.upcase} updates in a row"
    end
  end
end
