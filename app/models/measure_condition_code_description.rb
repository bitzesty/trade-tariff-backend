class MeasureConditionCodeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :language
  belongs_to :measure_condition_code, foreign_key: :condition_code
end

# == Schema Information
#
# Table name: measure_condition_code_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  condition_code         :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

