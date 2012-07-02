class QuotaSuspensionPeriod < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :quota_definition, primary_key: :quota_definition_sid
end
