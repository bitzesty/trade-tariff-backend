class MeasureConditionCode < ActiveRecord::Base
  set_primary_keys :condition_code

  has_one :measure_condition_code_description, foreign_key: :condition_code
end

# == Schema Information
#
# Table name: measure_condition_codes
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  condition_code         :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

