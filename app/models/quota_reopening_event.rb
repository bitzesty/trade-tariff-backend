class QuotaReopeningEvent < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end
