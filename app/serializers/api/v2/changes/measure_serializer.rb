module Api
  module V1
    module Changes
      class MeasureSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_sid
        set_type :measure
        attributes :id, :origin, :import, :goods_nomenclature_item_id

        has_one :geographical_area, serializer: Api::V1::Changes::GeographicalAreaSerializer
        has_one :measure_type, serializer: Api::V1::Changes::MeasureTypeSerializer

      end
    end
  end
end