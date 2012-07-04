class DutyExpression < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :measures
  has_many :measure_components
  has_many :measure_condition_components
end

# == Schema Information
#
# Table name: duty_expressions
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  duty_expression_id                  :string(255)
#  validity_start_date                 :date
#  validity_end_date                   :date
#  duty_amount_applicability_code      :integer(4)
#  measurement_unit_applicability_code :integer(4)
#  monetary_unit_applicability_code    :integer(4)
#  created_at                          :datetime
#  updated_at                          :datetime
#

