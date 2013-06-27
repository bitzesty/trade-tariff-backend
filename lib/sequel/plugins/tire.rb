module Sequel
  module Plugins
    module Tire
      module DatasetMethods
        # Alias for Tire
        # Compatibility with ActiveRecord
        # Use on models that are indexed with Tire
        def size
          count
        end
      end
    end
  end
end

