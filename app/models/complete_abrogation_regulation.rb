class CompleteAbrogationRegulation < Sequel::Model
  set_primary_key [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]

  # has_many :modification_regulations
  # has_many :base_regulations, foreign_key: [:complete_abrogation_regulation_role,
  #                                           :complete_abrogation_regulation_id]
  # belongs_to :complete_abrogation_regulation_role_type, foreign_key: :complete_abrogation_regulation_role_type,
  #                                                       class_name: 'RegulationRoleType'
end


