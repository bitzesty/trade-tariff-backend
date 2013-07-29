######### Conformance validations 110
class CertificateTypeValidator < TradeTariffBackend::Validator
  validation :CET1, 'The type of the certificate must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:certificate_type_code]
  end

  validation :CET2, 'The certificate type cannot be deleted if it is used in a certificate.', on: [:destroy] do |record|
    record.certificates.none?
  end

  validation :CET3, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
