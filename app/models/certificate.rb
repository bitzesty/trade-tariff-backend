class Certificate < Sequel::Model
  plugin :oplog, primary_key: [:certificate_code, :certificate_type_code]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:certificate_code, :certificate_type_code]

  many_to_many :certificate_descriptions, join_table: :certificate_description_periods,
                                          left_key: [:certificate_code, :certificate_type_code],
                                          right_key: :certificate_description_period_sid do |ds|
    ds.with_actual(CertificateDescriptionPeriod)
      .order(Sequel.desc(:certificate_description_periods__validity_start_date))
  end

  def certificate_description
    certificate_descriptions.first
  end

  one_to_many :certificate_types, key: :certificate_type_code,
                                  primary_key: :certificate_type_code do |ds|
    ds.with_actual(CertificateType)
  end

  def certificate_type
    certificate_types.first
  end

  delegate :description, to: :certificate_description
end


