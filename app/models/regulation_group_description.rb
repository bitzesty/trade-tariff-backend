class RegulationGroupDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :regulation_group
  belongs_to :language
end
