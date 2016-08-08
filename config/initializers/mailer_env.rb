# initializer which can be overwritten at deployment time to
# differentiate between development, staging, production, etc.
MAILER_ENV = Rails.application.secrets.mailer_env || Rails.env
