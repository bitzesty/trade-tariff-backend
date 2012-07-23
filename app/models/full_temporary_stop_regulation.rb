class FullTemporaryStopRegulation < Sequel::Model
  set_primary_key [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role]

  # has_many :fts_regulation_actions, foreign_key: [:fts_regulation_id, :fts_regulation_role]
  # has_many :fts_regulations, through: :fts_regulation_actions,
  #                            class_name: 'FullTemporaryStopRegulation'
  # has_many :stopped_fts_regulation_actions, foreign_key: [:stopped_regulation_id, :stopped_regulation_role],
  #                                           class_name: 'FtsRegulationAction'
  # has_many :stopped_fts_regulations, through: :stopped_fts_regulation_actions,
  #                                    class_name: 'FullTemporaryStopRegulation'

  # belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
  #                                                           :explicit_abrogation_regulation_id]
  # belongs_to :full_temporary_stop_regulation_role_type, foreign_key: :full_temporary_stop_regulation_role,
  #                                                       class_name: 'RegulationRoleType'
end


