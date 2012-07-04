class MeasureAction < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :action_code,
                        class_name: 'MeasureActionDescription'
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

