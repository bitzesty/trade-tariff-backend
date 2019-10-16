module Cache
  class HeadingIndex < ::Cache::CacheIndex
    def definition
      {
        mappings: {
          heading: {
            dynamic: false,
            properties: {}
          }
        }
      }
    end
  end
end