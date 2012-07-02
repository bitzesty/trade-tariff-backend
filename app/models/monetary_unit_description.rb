class MonetaryUnitDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :monetary_unit, foreign_key: :monetary_unit_code
  belongs_to :language
end
