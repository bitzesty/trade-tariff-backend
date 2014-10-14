require "raven"

Raven.configure do |config|
  config.environments = %w[ development ]
  config.dsn = "https://3bee46b6981347afbf075c2179190c94:1cdaa52a99be454eb995830c1306b811@app.getsentry.com/30337"
end
