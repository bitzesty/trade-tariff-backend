module Api
  module V1
    module Measures
      class OverviewMeasureSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_sid
        set_type :measure

        attributes :id, :vat

        has_one :duty_expression, serializer: Api::V1::Measures::DutyExpressionSerializer
        has_one :measure_type, serializer: Api::V1::Measures::MeasureTypeSerializer
      end
    end
  end
end