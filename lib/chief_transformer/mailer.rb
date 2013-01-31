require 'mailer_environment'

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

      mail subject: "#{subject_prefix(:error)} Failed CHIEF transformation"
    end
  end
end
