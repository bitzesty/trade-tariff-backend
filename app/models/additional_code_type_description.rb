class AdditionalCodeTypeDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :additional_code_type, foreign_key: :additional_code_type_id
  belongs_to :language
end
