class CertificateType < Sequel::Model
  plugin :time_machine

  set_primary_key :certificate_type_code

  many_to_one :certificate_type_description, key: :certificate_type_code,
                                             primary_key: :certificate_type_code,
                                             eager_loader_key: :certificate_type_code

  one_to_many :certificates, key: :certificate_type_code,
                             primary_key: :certificate_type_code

  delegate :description, to: :certificate_type_description

  ######### Conformance validations 110
  validates do
    # CET1
    uniqueness_of :certificate_type_code
    # CET3
    validity_dates
  end

  def before_destroy
    # CET2
    return false if certificates.any?

    super
  end
end


