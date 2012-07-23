class CertificateTypeDescription < Sequel::Model
  set_primary_key  :certificate_type_code

  # belongs_to :certificate_type, foreign_key: :certificate_type_code
  # belongs_to :language
end


