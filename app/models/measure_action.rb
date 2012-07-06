class MeasureAction < ActiveRecord::Base
  self.primary_keys =  :action_code

  has_one :measure_action_description, foreign_key: :action_code
  has_many :measure_conditions, foreign_key: :action_code
end

# == Schema Information
#
# Table name: measure_actions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  action_code            :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

