class CertificateType < ActiveRecord::Base
  self.primary_key = :certificate_type_code

  has_one :certificate_type_description
  has_many :measure_conditions, foreign_key: :certificate_type_code
end
