# Tire gem is not directly compatible with Sequel models
# This plugin adds compaitiblity layer to Sequel models
module Sequel
  module Plugins
    module Tire
      def self.apply(model, opts=OPTS)
        # Tire model has to comply to ActiveModel
        model.plugin(:active_model)
        # Tire search methods
        model.include(::Tire::Model::Search)
      end

      module DatasetMethods
        # Alias for Tire
        # Compatibility with ActiveRecord
        # Use on models that are indexed with Tire
        def size
          count
        end
      end

      module InstanceMethods
        def destroyed?
          @destroyed || false
        end
      end
    end
  end
end

