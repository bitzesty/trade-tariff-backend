module Api
  module Admin
    module Chemicals
      class ChemicalNameSerializer
        include JSONAPI::Serializer

        attributes :name, :chemical_id
      end
    end
  end
end
