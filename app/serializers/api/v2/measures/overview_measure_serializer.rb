module Api
  module V2
    module Measures
      class OverviewMeasureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :measure

        set_id :measure_sid

        attributes :id, :vat

        has_one :duty_expression, serializer: Api::V2::Measures::DutyExpressionSerializer
        has_one :measure_type, serializer: Api::V2::Measures::MeasureTypeSerializer
      end
    end
  end
end
