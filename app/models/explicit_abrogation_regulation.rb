class ExplicitAbrogationRegulation < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :modification_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                    :explicit_abrogation_regulation_id]
  has_many :full_temporary_stop_regulations, foreign_key: [:explicit_abrogation_regulation_role,
                                                           :explicit_abrogation_regulation_id]
end
