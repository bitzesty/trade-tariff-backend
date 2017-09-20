require "sidekiq"

redis_url = begin
  JSON.parse(ENV["VCAP_SERVICES"])["user-provided"].select{ |s| s["name"] == "redis-alpha" }[0]["credentials"]["uri"]
rescue
  ENV["REDIS_URL"]
end

redis_db = ENV["REDIS_DB"] || 0

redis_config = { url: redis_url, db: redis_db }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
