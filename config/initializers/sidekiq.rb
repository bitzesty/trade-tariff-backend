require "sidekiq"

# PaaS Redis is not ready for prod
if TradeTariffBackend.production?
  redis_url = ENV["REDIS_URL"]
  # db > 1 does not work for old redis service, but when we will switch to PaaS redis it should work
  redis_db = 0
else
  redis_url = begin
    JSON.parse(ENV["VCAP_SERVICES"])["user-provided"].select{ |s| s["name"] == "redis-alpha" }[0]["credentials"]["uri"]
  rescue
    ENV["REDIS_URL"]
  end
  redis_db = ENV["REDIS_DB"] || 0
end

redis_config = { url: redis_url, db: redis_db }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
