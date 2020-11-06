module Cache
  class CacheIndex < ::SearchIndex
    def name
      "#{super}-cache"
    end
  end
end
