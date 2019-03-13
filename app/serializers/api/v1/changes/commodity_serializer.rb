module Api
  module V1
    module Changes
      class CommoditySerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :commodity
        attributes :description, :goods_nomenclature_item_id, :validity_start_date, :validity_end_date
      end
    end
  end
end