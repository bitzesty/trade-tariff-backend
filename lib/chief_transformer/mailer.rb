require 'mailer_environment'

class ChiefTransformer
  class Mailer < ActionMailer::Base
    include MailerEnvironment

    default from: TradeTariffBackend.from_email,
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
