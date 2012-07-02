class ProrogationRegulation < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :prorogation_regulation_actions, foreign_key: [:prorogation_regulation_role,
                                                          :prorogation_regulation_id],
                                            class_name: 'ProrogationRegulationAction'
  has_many :prorogated_regulation_actions, foreign_key: [:prorogated_regulation_role,
                                                          :prorogated_regulation_id],
                                            class_name: 'ProrogationRegulationAction'

  belongs_to :base_regulation, foreign_key: [:prorogation_regulation_role, :prorogation_regulation_id],
                               class_name: 'BaseRegulation'
end
