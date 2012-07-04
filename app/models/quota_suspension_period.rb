class QuotaSuspensionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :quota_definition, primary_key: :quota_definition_sid
end
