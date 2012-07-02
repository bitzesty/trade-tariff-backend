class DutyExpression < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :measures
  has_many :measure_components
  has_many :measure_condition_components
end
