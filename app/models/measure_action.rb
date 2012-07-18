class MeasureAction < Sequel::Model
  plugin :time_machine

  set_primary_key :action_code

  one_to_one :measure_action_description, key: :action_code,
                                          primary_key: :action_code
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

