require 'mailer_environment'

module TariffSynchronizer
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: TradeTariffBackend.from_email,
            to: TradeTariffBackend.admin_email

    def exception(exception, update, database_queries)
      @failed_file_path = update.file_path
      @exception = exception

      if exception.respond_to?(:original) && exception.original.presence
        @exception = exception.original.presence
      end

      @database_queries = database_queries

      mail subject: "#{subject_prefix(:error)} Failed Trade Tariff update"
    end

    def failed_download(exception, url)
      @url = url
      @exception = exception

      mail subject: "#{subject_prefix(:error)} Trade Tariff download failure"
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

    def applied(update_names, conformance_errors = [])
      @update_names = update_names
      @conformance_errors = conformance_errors

      mail subject: "#{subject_prefix(:info)} Tariff updates applied"
    end

    def missing_updates(count, update_type)
      @count = count
      @update_type = update_type

      mail subject: "#{subject_prefix(:warn)} Missing #{count} #{update_type.upcase} updates in a row"
    end
  end
end
