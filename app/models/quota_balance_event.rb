class QuotaBalanceEvent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end
