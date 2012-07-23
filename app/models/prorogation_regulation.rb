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


