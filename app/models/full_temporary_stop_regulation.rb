class FullTemporaryStopRegulation < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :fts_regulation_actions, foreign_key: [:fts_regulation_role, :fts_regulation_id]
  has_many :stopped_fts_regulation_actions, foreign_key: [:stopped_regulation_role, :stopped_regulation_id],
                                            class_name: 'FtsRegulationAction'
  belongs_to :explicit_abrogation_regulation, foreign_key: [:explicit_abrogation_regulation_role,
                                                            :explicit_abrogation_regulation_id]
end
