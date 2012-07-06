class MeasureConditionComponent < ActiveRecord::Base
  self.primary_keys =  :measure_condition_sid

  belongs_to :duty_expression, foreign_key: :duty_expression_id
  belongs_to :measure_condition, foreign_key: :measure_condition_sid
  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :monetary_unit, foreign_key: :monetary_unit_code
end

# == Schema Information
#
# Table name: measure_condition_components
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  measure_condition_sid           :integer(4)
#  duty_expression_id              :string(255)
#  duty_amount                     :integer(4)
#  monetary_unit_code              :string(255)
#  measurement_unit_code           :string(255)
#  measurement_unit_qualifier_code :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#

