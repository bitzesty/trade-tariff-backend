module Api
  module V2
    module Certificates
      class MeasureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :measure

        set_id :measure_sid

        attributes :id, :validity_start_date, :validity_end_date

        has_one :goods_nomenclature, id_method_name: :goods_nomenclature_sid, serializer: Api::V2::Certificates::GoodsNomenclatureSerializer
      end
    end
  end
end