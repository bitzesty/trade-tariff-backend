class RegulationGroupDescription < Sequel::Model
  set_primary_keys  :regulation_group_id

  # belongs_to :regulation_group
  # belongs_to :language
end

# == Schema Information
#
# Table name: regulation_group_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  regulation_group_id    :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

