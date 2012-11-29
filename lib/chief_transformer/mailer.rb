class ChiefTransformer
  class Mailer < ActionMailer::Base
    default from: "DO NOT REPLY <trade-tariff-alerts@digital.cabinet-office.gov.uk>",
            to: TradeTariffBackend.admin_email

    def successful_transformation_notice
      mail subject: '[info] Successful CHIEF transformation'
    end

    def failed_transformation_notice(operation, exception, model, errors)
      @operation = operation
      @exception = exception
      @model = model
      @errors = errors

      mail subject: '[error] Failed CHIEF transformation'
    end
  end
end
