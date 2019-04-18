module Api
  module V2
    module Changes
      class GoodsNomenclatureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :goods_nomenclature

        set_id :goods_nomenclature_sid

        attributes :description, :goods_nomenclature_item_id, :validity_start_date, :validity_end_date
      end
    end
  end
end
