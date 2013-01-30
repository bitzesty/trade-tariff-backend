module TradeTariffBackend
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def reindex_exception(exception)
      @exception = exception

      mail subject: "[error] Trade Tariff reindex failure #{environment_indicator}"
    end
  end
end
