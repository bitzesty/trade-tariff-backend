module RedisResolver
  module_function

  def get_redis_config
    redis_url = begin
      # TODO: !Important
      # need to fetch by service name if we use multiple redis services
      JSON.parse(ENV["VCAP_SERVICES"])["redis"][0]["credentials"]["uri"]
    rescue
      ENV["REDIS_URL"]
    end

    { url: redis_url, db: 0 }
  end
end
