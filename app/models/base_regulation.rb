class BaseRegulation < ActiveRecord::Base
  set_primary_keys :base_regulation_id, :base_regulation_role

  belongs_to :regulation_group
  has_many :modification_regulations

  belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
                                                            :explicit_abrogation_regulation_id]
  belongs_to :complete_abrogation_regulation, foreign_key: [:complete_abrogation_regulation_role,
                                                            :complete_abrogation_regulation_id]
  belongs_to :antidumping_regulation, foreign_key: [:antidumping_regulation_role,
                                                    :related_antidumping_regulation_id],
                                      class_name: 'BaseRegulation'
  belongs_to :base_regulation_role_type, foreign_key: :base_regulation_role,
                                    class_name: 'RegulationRoleType'
  belongs_to :antidumping_regulation_role_type, foreign_key: :antidumping_regulation_role,
                                           class_name: 'RegulationRoleType'
  belongs_to :complete_abrogation_regulation_role_type, foreign_key: :complete_abrogation_regulation_role,
                                                   class_name: 'RegulationRoleType'
  belongs_to :explicit_abrogation_regulation_role_type, foreign_key: :explicit_abrogation_regulation_role,
                                                   class_name: 'RegulationRoleType'


  has_many :replacing_regulation_replacements, foreign_key: [:replacing_regulation_role,
                                                             :replacing_regulation_id],
                                               class_name: 'RegulationReplacement'

  has_many :replaced_regulation_replacements, foreign_key: [:replaced_regulation_role,
                                                            :replaced_regulation_id],
                                               class_name: 'RegulationReplacement'
  has_many :prorogation_regulation_replacements, foreign_key: [:prorogation_regulation_role,
                                                               :prorogation_regulation_id],
                                                 class_name: 'BaseRegulation'
  has_many :modification_regulations, foreign_key: [:base_regulation_id,
                                                    :base_regulation_role]
  has_many :modified_explicit_abrogation_regulations, through: :modification_regulations,
                                                      source: :explicit_abrogation_regulation
  has_many :modified_complete_abrogation_regulations, through: :modification_regulations,
                                                      source: :complete_abrogation_regulation
  has_many :prorogation_regulations, foreign_key: [:base_regulation_id,
                                                   :base_regulation_role]
end

# == Schema Information
#
# Table name: base_regulations
#
#  record_code                         :string(255)
#  subrecord_code                      :string(255)
#  record_sequence_number              :string(255)
#  base_regulation_role                :integer(4)
#  base_regulation_id                  :string(255)
#  validity_start_date                 :date
#  validity_end_date                   :date
#  community_code                      :integer(4)
#  regulation_group_id                 :string(255)
#  replacement_indicator               :integer(4)
#  stopped_flag                        :boolean(1)
#  information_text                    :text
#  approved_flag                       :boolean(1)
#  published_date                      :date
#  officialjournal_number              :string(255)
#  officialjournal_page                :integer(4)
#  effective_end_date                  :date
#  antidumping_regulation_role         :integer(4)
#  related_antidumping_regulation_id   :string(255)
#  complete_abrogation_regulation_role :integer(4)
#  complete_abrogation_regulation_id   :string(255)
#  explicit_abrogation_regulation_role :integer(4)
#  explicit_abrogation_regulation_id   :string(255)
#  created_at                          :datetime
#  updated_at                          :datetime
#

