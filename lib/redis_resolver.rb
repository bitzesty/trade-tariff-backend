module RedisResolver
  module_function

  def get_redis_config
    # PaaS Redis is not ready for prod
    redis_url = if TradeTariffBackend.production?
      ENV["REDIS_URL"]
    else
      begin
        # TODO: !Important
        # need to fetch by service name if we use multiple redis services
        JSON.parse(ENV["VCAP_SERVICES"])["redis"][0]["credentials"]["uri"]
      rescue
        ENV["REDIS_URL"]
      end
    end
    { url: redis_url, db: 0 }
  end
end
