class RegulationGroupDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :regulation_group
  belongs_to :language
end
