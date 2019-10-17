module Api
  module V2
    module Chemicals
      class ChemicalListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chemical

        set_id :id

        attributes :id, :cas
        attribute :name do |chemical|
          chemical.name
        end
      end
    end
  end
end
