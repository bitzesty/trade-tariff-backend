class BaseRegulation < Sequel::Model
  plugin :time_machine, period_end_column: :effective_end_date

  set_primary_key [:base_regulation_id, :base_regulation_role]

  # belongs_to :regulation_group
  # has_many :modification_regulations

  # has_many :measures, foreign_key: [:measure_generating_regulation_id,
  #                                   :measure_generating_regulation_role]

  # belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
  #                                                           :explicit_abrogation_regulation_id]
  # belongs_to :complete_abrogation_regulation, foreign_key: [:complete_abrogation_regulation_role,
  #                                                           :complete_abrogation_regulation_id]
  # belongs_to :antidumping_regulation, foreign_key: [:antidumping_regulation_role,
  #                                                   :related_antidumping_regulation_id],
  #                                     class_name: 'BaseRegulation'
  # belongs_to :base_regulation_role_type, foreign_key: :base_regulation_role,
  #                                   class_name: 'RegulationRoleType'
  # belongs_to :antidumping_regulation_role_type, foreign_key: :antidumping_regulation_role,
  #                                          class_name: 'RegulationRoleType'
  # belongs_to :complete_abrogation_regulation_role_type, foreign_key: :complete_abrogation_regulation_role,
  #                                                  class_name: 'RegulationRoleType'
  # belongs_to :explicit_abrogation_regulation_role_type, foreign_key: :explicit_abrogation_regulation_role,
  #                                                  class_name: 'RegulationRoleType'


  # has_many :replacing_regulation_replacements, foreign_key: [:replacing_regulation_role,
  #                                                            :replacing_regulation_id],
  #                                              class_name: 'RegulationReplacement'

  # has_many :replaced_regulation_replacements, foreign_key: [:replaced_regulation_role,
  #                                                           :replaced_regulation_id],
  #                                              class_name: 'RegulationReplacement'
  # has_many :prorogation_regulation_replacements, foreign_key: [:prorogation_regulation_role,
  #                                                              :prorogation_regulation_id],
  #                                                class_name: 'BaseRegulation'
  # has_many :modification_regulations, foreign_key: [:base_regulation_id,
  #                                                   :base_regulation_role]
  # has_many :modified_explicit_abrogation_regulations, through: :modification_regulations,
  #                                                     source: :explicit_abrogation_regulation
  # has_many :modified_complete_abrogation_regulations, through: :modification_regulations,
  #                                                     source: :complete_abrogation_regulation
  # has_many :prorogation_regulations, foreign_key: [:base_regulation_id,
  #                                                  :base_regulation_role]

  # scope :effective_on, ->(date) { where{(validity_start_date.lte date) &
  #                                   ((effective_end_date.gte date) |
  #                                    (effective_end_date.eq nil)
  #                                   )}
  #                               }
end


