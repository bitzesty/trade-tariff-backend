class CertificateType < Sequel::Model
  set_primary_key :certificate_type_code

  # has_one  :certificate_type_description, foreign_key: :certificate_type_code
  # has_many :certificates, foreign_key: :certificate_type_code
  # has_many :measure_conditions, foreign_key: :certificate_type_code
end


