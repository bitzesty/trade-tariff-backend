Airbrake.configure do |config|
  config.port    = 443
  config.secure  = true
  config.host    = Rails.application.secrets.errbit_host
  config.api_key = Rails.application.secrets.errbit_api_key
end
