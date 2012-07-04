class MonetaryUnitDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :monetary_unit, foreign_key: :monetary_unit_code
  belongs_to :language
end
