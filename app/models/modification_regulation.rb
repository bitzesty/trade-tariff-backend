class ModificationRegulation < ActiveRecord::Base
  self.primary_key = [:modification_regulation_role, :modification_regulation_id]

  belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
                                                            :explicit_abrogation_regulation_id]
  belongs_to :complete_abrogation_regulation, foreign_key: [:complete_abrogation_regulation_role,
                                                            :complete_abrogation_regulation_id]
  belongs_to :base_regulations, foreign_key: [:base_regulation_role,
                                              :base_regulation_id]
end
