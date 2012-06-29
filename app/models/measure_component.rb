class MeasureComponent < ActiveRecord::Base
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :measurement, foreign_key: [:measurement_unit_code, :measurement_unit_qualifier_code]
  belongs_to :duty_expression
end
