Sidekiq.configure_client do |config|
  config.redis = { namespace: 'tariff-api' }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'tariff-api' }
end
