class ExplicitAbrogationRegulation < ActiveRecord::Base
  self.primary_key = [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id]

  has_many :modification_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                    :explicit_abrogation_regulation_id]
  has_many :full_temporary_stop_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                           :explicit_abrogation_regulation_id]
end
