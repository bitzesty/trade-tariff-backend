Airbrake.configure do |config|
  config.api_key     = 'e69ba9033db17057825a09a0f2532cff'
  config.host        = 'errbit.apps.bitzesty.com'
  config.port        = 80
  config.secure      = config.port == 443
end
