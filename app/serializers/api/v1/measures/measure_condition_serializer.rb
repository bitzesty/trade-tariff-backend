module Api
  module V1
    module Measures
      class MeasureConditionSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_condition_sid
        set_type :measure_condition
        attributes :condition_code, :condition, :document_code, :requirement, :action, :duty_expression
      end
    end
  end
end