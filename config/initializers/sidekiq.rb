# This file is overwritten on deploy

debug_redis = false

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'tariff-api', logger: Logger.new(debug_redis ? $stdout : "/dev/null") }
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'tariff-api' }
end
