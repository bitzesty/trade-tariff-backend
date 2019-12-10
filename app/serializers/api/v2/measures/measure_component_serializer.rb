module Api
  module V2
    module Measures
      class MeasureComponentSerializer
        include FastJsonapi::ObjectSerializer

        set_type :measure_component

        set_id do |obj|
          obj.pk.join('-')
        end

        attributes :duty_expression_id, :duty_amount, :monetary_unit_code, :monetary_unit_abbreviation,
                   :measurement_unit_code, :duty_expression_description, :duty_expression_abbreviation
      end
    end
  end
end
