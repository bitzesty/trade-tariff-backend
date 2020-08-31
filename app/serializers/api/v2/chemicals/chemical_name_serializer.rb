module Api
  module V2
    module Chemicals
      class ChemicalNameSerializer
        include JSONAPI::Serializer

        attributes :name, :chemical_id
      end
    end
  end
end
