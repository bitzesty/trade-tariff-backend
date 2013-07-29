class TaricImporter < TariffImporter
  module Helpers
    module StringHelper
      extend ActiveSupport::Concern

      private

      def as_strategy(name)
        as_param(name).camelcase.singularize
      end

      def as_param(name)
        name.parameterize("_")
      end
    end
  end
end
