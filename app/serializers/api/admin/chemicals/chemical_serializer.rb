module Api
  module Admin
    module Chemicals
      class ChemicalSerializer
        include JSONAPI::Serializer

        set_type :chemical

        set_id :id

        link :uri do |object|
          "/admin/chemicals/#{object.id}"
        end

        attribute :id, &:id_to_s
        attribute :cas
        attribute :name, &:name

        has_many :goods_nomenclatures, serializer: Api::Admin::Commodities::CommoditySerializer
        has_many :chemical_names
      end
    end
  end
end
