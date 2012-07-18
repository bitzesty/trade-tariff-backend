class CompleteAbrogationRegulation < ActiveRecord::Base
  set_primary_key  [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]

  # has_many :modification_regulations
  # has_many :base_regulations, foreign_key: [:complete_abrogation_regulation_role,
  #                                           :complete_abrogation_regulation_id]
  # belongs_to :complete_abrogation_regulation_role_type, foreign_key: :complete_abrogation_regulation_role_type,
  #                                                       class_name: 'RegulationRoleType'
end

# == Schema Information
#
# Table name: complete_abrogation_regulations
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  complete_abrogation_regulation_role :integer(4)
#  complete_abrogation_regulation_id   :string(255)
#  published_date                      :date
#  officialjournal_number              :string(255)
#  officialjournal_page                :integer(4)
#  replacement_indicator               :integer(4)
#  information_text                    :text
#  approved_flag                       :boolean(1)
#  created_at                          :datetime
#  updated_at                          :datetime
#

