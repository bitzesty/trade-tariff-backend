Redis::Classy.db = Sidekiq.redis { |conn| conn }
