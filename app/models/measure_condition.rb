class MeasureCondition < ActiveRecord::Base
  set_primary_keys :measure_condition_sid

  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :action, foreign_key: :action_code, class_name: 'MeasureAction'
  belongs_to :code, foreign_key: :condition_code, class_name: 'MeasureConditionCode'
  belongs_to :certificate, foreign_key: [:certificate_code, :certificate_type_code]
  belongs_to :certificate_type, foreign_key: :certificate_type_code,
                                class_name: 'CertificateType'
end

# == Schema Information
#
# Table name: measure_conditions
#
#  record_code                               :string(255)
#  subrecord_code                            :string(255)
#  record_sequence_number                    :string(255)
#  measure_condition_sid                     :integer(4)
#  measure_sid                               :integer(4)
#  condition_code                            :string(255)
#  component_sequence_number                 :integer(4)
#  condition_duty_amount                     :integer(4)
#  condition_monetary_unit_code              :string(255)
#  condition_measurement_unit_code           :string(255)
#  condition_measurement_unit_qualifier_code :string(255)
#  action_code                               :string(255)
#  certificate_type_code                     :string(255)
#  certificate_code                          :string(255)
#  created_at                                :datetime
#  updated_at                                :datetime
#

