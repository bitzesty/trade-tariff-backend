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
  def validate
    super
    # CET1
    validates_unique :certificate_type_code
    # CET3
    validates_start_date
  end

  def before_destroy
    # CET2
    return !certificates.any?

    super
  end
end


