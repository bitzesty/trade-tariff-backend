module Api
  module Admin
    module Commodities
      class CommoditySerializer
        include JSONAPI::Serializer

        set_type :commodity

        set_id :goods_nomenclature_sid

        attributes :description, :goods_nomenclature_item_id
      end
    end
  end
end
