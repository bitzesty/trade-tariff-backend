require "sidekiq"

redis_config = PaasResolver.get_redis_config

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
