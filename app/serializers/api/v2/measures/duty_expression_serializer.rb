module Api
  module V2
    module Measures
      class DutyExpressionSerializer
        include FastJsonapi::ObjectSerializer
        set_id :id
        set_type :duty_expression
        attributes :base, :formatted_base
      end
    end
  end
end