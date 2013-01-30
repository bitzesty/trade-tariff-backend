class ChiefTransformer
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def failed_transformation_notice(operation, exception, model, errors)
      @operation = operation
      @exception = exception
      @model = model
      @errors = errors

      mail subject: "[error] Failed CHIEF transformation #{environment_indicator}"
    end
  end
end
