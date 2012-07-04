class QuotaCriticalEvent < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end
