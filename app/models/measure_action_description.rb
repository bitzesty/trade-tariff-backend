class MeasureActionDescription < ActiveRecord::Base
  set_primary_keys :action_code

  belongs_to :measure_action, foreign_key: :action_code
  belongs_to :language
end

# == Schema Information
#
# Table name: measure_action_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  action_code            :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

