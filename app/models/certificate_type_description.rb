class CertificateTypeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :certificate_type, foreign_key: :certificate_type_code
  belongs_to :language
end
