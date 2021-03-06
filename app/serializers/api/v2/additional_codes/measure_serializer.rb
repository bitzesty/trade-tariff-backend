module Api
  module V2
    module AdditionalCodes
      class MeasureSerializer
        include JSONAPI::Serializer

        set_type :measure

        set_id :measure_sid

        attributes :id, :validity_start_date, :validity_end_date, :goods_nomenclature_item_id

        has_one :goods_nomenclature, id_method_name: :goods_nomenclature_sid, serializer: Api::V2::AdditionalCodes::GoodsNomenclatureSerializer
      end
    end
  end
end
