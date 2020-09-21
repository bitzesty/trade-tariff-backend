module Api
  module V2
    module Measures
      class ShortMeasureSerializer
        include JSONAPI::Serializer

        set_type :measure

        set_id :measure_sid

        attributes :id, :origin, :goods_nomenclature_item_id, :validity_start_date, :validity_end_date
      end
    end
  end
end
