class RegulationRoleType < ActiveRecord::Base
  self.primary_keys =  :regulation_role_type_id

  has_one :regulation_role_type_description, foreign_key: :regulation_role_type_id
  has_many :base_regulations, foreign_key: :base_regulation_role
  has_many :antidumping_regulations, foreign_key: :antidumping_regulation_role,
                                     class_name: 'BaseRegulation'
  has_many :complete_abrogation_regulations, foreign_key: :complete_abrogation_regulation_role,
                                             class_name: 'CompleteAbrogationRegulation'
  has_many :explicit_abrogation_regulations, foreign_key: :explicit_abrogation_regulation_role,
                                             class_name: 'ExplicitAbrogationRegulation'
  has_many :fts_regulation_actions, foreign_key: :fts_regulation_role,
                                    class_name: 'FtsRegulationAction'
  has_many :fts_regulation_stopped_actions, foreign_key: :stopped_regulation_role,
                                            class_name: 'FtsRegulationAction'
  has_many :full_temporary_stop_regulations, foreign_key: :full_temporary_stop_regulation_role
  has_many :modification_regulations, foreign_key: :modification_regulation_role
  has_many :prorogation_regulations, foreign_key: :prorogation_regulation_role
end

# == Schema Information
#
# Table name: regulation_role_types
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  regulation_role_type_id :string(255)
#  validity_start_date     :date
#  validity_end_date       :date
#  created_at              :datetime
#  updated_at              :datetime
#

