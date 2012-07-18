class ProrogationRegulation < Sequel::Model
  set_primary_key  :prorogation_regulation_id, :prorogation_regulation_role

  # has_many :prorogation_regulation_actions, foreign_key: [:prorogation_regulation_role,
  #                                                         :prorogation_regulation_id],
  #                                           class_name: 'ProrogationRegulationAction'
  # has_many :prorogated_regulation_actions, foreign_key: [:prorogated_regulation_role,
  #                                                         :prorogated_regulation_id],
  #                                           class_name: 'ProrogationRegulationAction'

  # belongs_to :base_regulation, foreign_key: [:prorogation_regulation_role, :prorogation_regulation_id],
  #                              class_name: 'BaseRegulation'
  # belongs_to :prorogation_regulation_role_type, foreign_key: :prorogation_regulation_role,
  #                                               class_name: 'RegulationRoleType'
end

# == Schema Information
#
# Table name: prorogation_regulations
#
#  record_code                 :string(255)
#  subrecord_code              :string(255)
#  record_sequence_number      :string(255)
#  prorogation_regulation_role :integer(4)
#  prorogation_regulation_id   :string(255)
#  published_date              :date
#  officialjournal_number      :string(255)
#  officialjournal_page        :integer(4)
#  replacement_indicator       :integer(4)
#  information_text            :text
#  approved_flag               :boolean(1)
#  created_at                  :datetime
#  updated_at                  :datetime
#

