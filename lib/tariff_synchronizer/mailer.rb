module TariffSynchonizer
  class Mailer < ActionMailer::Base
    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TariffSynchronizer.admin_email

    def exception(exception, update)
      @failed_file_path = update.file_path
      @exception = exception

      mail subject: "Failed Trade Tariff update", data: data
    end

    def failures_reminder(file_names)
      mail subject: "Failed Trade Tariff updates still present", file_names: file_names
    end
  end
end
