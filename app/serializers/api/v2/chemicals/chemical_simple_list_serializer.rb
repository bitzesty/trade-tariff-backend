module Api
  module V2
    module Chemicals
      class ChemicalSimpleListSerializer
        include JSONAPI::Serializer

        set_type :chemical

        set_id :id

        attributes :id, :cas
        attribute :name, &:name
      end
    end
  end
end
