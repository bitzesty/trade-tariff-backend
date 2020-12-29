module Api
  module V2
    module Chemicals
      class ChemicalNameSerializer
        include JSONAPI::Serializer

        set_type :chemical_name
        set_id :id

        attributes :name, :chemical_id
      end
    end
  end
end
