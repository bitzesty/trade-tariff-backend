class Certificate < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  belongs_to :certificate_type, foreign_key: :certificate_type_code
  has_many :measure_conditions, foreign_key: :certificate_type
end
