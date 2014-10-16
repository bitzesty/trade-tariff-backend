# This file is overwritten on deploy

debug_redis = false

url = if ENV['REDIS_1_PORT_6379_TCP'].present?
    ENV['REDIS_1_PORT_6379_TCP']
  else
    "redis://localhost:6379"
  end

Sidekiq.configure_client do |config|
  config.redis = { url: url, namespace: 'tariff-api', logger: Logger.new(debug_redis ? $stdout : "/dev/null") }
end

Sidekiq.configure_server do |config|
  config.redis = { url: url, namespace: 'tariff-api' }
end
