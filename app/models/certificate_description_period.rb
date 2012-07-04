class CertificateDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :certificate_type, foreign_key: :certificate_type_code
  belongs_to :certificate, foreign_key: :certificate_code
end
