class MeasureComponent < Sequel::Model
  set_primary_key :measure_sid, :duty_expression_id

  one_to_one :duty_expression, key: {}, primary_key: {}, dataset: -> {
    DutyExpression.actual
                  .where(duty_expression_id: duty_expression_id)
  }

  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  # belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  # belongs_to :duty_expression, foreign_key: :duty_expression_id
  # belongs_to :monetary_unit, foreign_key: :monetary_unit_code
end

# == Schema Information
#
# Table name: measure_components
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  measure_sid                     :integer(4)
#  duty_expression_id              :string(255)
#  duty_amount                     :integer(4)
#  monetary_unit_code              :string(255)
#  measurement_unit_code           :string(255)
#  measurement_unit_qualifier_code :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#

