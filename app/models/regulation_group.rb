class RegulationGroup < Sequel::Model
  set_primary_keys  :regulation_group_id

  # has_many :base_regulations
  # has_one  :regulation_group_description, foreign_key: :regulation_group_id
end

# == Schema Information
#
# Table name: regulation_groups
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  regulation_group_id    :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

