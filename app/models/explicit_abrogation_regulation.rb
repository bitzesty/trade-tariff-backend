class ExplicitAbrogationRegulation < Sequel::Model
  set_primary_key [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role]

  # has_many :modification_regulations, foreign_key: [:explicit_abrogation_regulation_role,
  #                                                   :explicit_abrogation_regulation_id]
  # has_many :full_temporary_stop_regulations, foreign_key: [:explicit_abrogation_regulation_role,
  #                                                          :explicit_abrogation_regulation_id]
  # has_many :base_regulations, foreign_key: [:explicit_abrogation_regulation_role,
  #                                           :explicit_abrogation_regulation_id]
end


