class CertificateType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :certificate_type_description
  has_many :measure_conditions, foreign_key: :certificate_type_code
end
