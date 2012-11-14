module TariffSynchonizer
  class Mailer < ActionMailer::Base
    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TariffSynchronizer.admin_email

    def exception(exception, update)
      @failed_file_path = update.file_path
      @exception = exception

      mail subject: 'Failed Trade Tariff update'
    end

    def failures_reminder(file_names)
      @file_names = file_names

      mail subject: 'Update application failed: failed Trade Tariff updates present'
    end

    def file_not_found_on_filesystem(path)
      @path = path

      mail subject: 'Update application failed: update file not found'
    end
  end
end
