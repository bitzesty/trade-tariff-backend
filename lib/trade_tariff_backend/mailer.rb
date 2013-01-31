module TradeTariffBackend
  class Mailer < ActionMailer::Base
    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def reindex_exception(exception)
      @exception = exception

      mail subject: "[error][#{TradeTariffBackend.platform}] Trade Tariff reindex failure"
    end
  end
end
