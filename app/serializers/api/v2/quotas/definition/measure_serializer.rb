module Api
  module V2
    module Quotas
      module Definition
        class MeasureSerializer
          include FastJsonapi::ObjectSerializer

          set_type :measure

          set_id :measure_sid

          attribute :goods_nomenclature_item_id

          has_one :geographical_area, serializer: Api::V2::GeographicalAreaSerializer
        end
      end
    end
  end
end