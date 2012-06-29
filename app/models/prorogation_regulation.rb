class ProrogationRegulation < ActiveRecord::Base
  self.primary_key = [:prorogation_regulation_role, :prorogation_regulation_id]

  has_many :prorogation_regulation_actions, foreign_key: [:prorogation_regulation_role,
                                                          :prorogation_regulation_id],
                                            class_name: 'ProrogationRegulationAction'
  has_many :prorogated_regulation_actions, :foreign_key: [:prorogated_regulation_role,
                                                          :prorogated_regulation_id],
                                            class_name: 'ProrogationRegulationAction'
end
