require "sidekiq"

redis_config = Rails.application.config_for(:redis).symbolize_keys

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
