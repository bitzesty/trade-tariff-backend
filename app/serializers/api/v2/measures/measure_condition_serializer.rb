module Api
  module V2
    module Measures
      class MeasureConditionSerializer
        include JSONAPI::Serializer

        set_type :measure_condition

        set_id :measure_condition_sid

        attributes :condition_code, :condition, :document_code, :requirement, :action, :duty_expression
      end
    end
  end
end
