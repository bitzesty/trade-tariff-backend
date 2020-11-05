module Cache
  class HeadingIndex < ::Cache::CacheIndex
    def definition
      {
        mappings: {
          dynamic: false,
          properties: {}
        }
      }
    end
  end
end
