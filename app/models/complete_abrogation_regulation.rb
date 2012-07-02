class CompleteAbrogationRegulation < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :modification_regulations
end
