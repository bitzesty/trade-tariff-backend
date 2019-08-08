class Certificate < Sequel::Model
  plugin :oplog, primary_key: %i[certificate_code certificate_type_code]
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key %i[certificate_code certificate_type_code]

  many_to_many :certificate_descriptions, join_table: :certificate_description_periods,
                                          left_key: %i[certificate_code certificate_type_code],
                                          right_key: :certificate_description_period_sid do |ds|
    ds.with_actual(CertificateDescriptionPeriod)
      .order(Sequel.desc(:certificate_description_periods__validity_start_date))
  end

  one_to_many :measure_conditions, key: %i[certificate_type_code certificate_code],
                                   primary_key: %i[certificate_type_code certificate_code]

  def measures
    @_measures ||= measure_conditions&.map(&:measure).select do |measure|
      point_in_time.blank? ||
        (measure.validity_start_date <= point_in_time &&
          (measure.validity_end_date == nil ||
            measure.validity_end_date >= point_in_time))
    end
  end

  def measure_ids
    measures&.map(&:measure_sid)
  end

  def certificate_description
    certificate_descriptions(reload: true).last
  end

  one_to_many :certificate_types, key: :certificate_type_code,
                                  primary_key: :certificate_type_code do |ds|
    ds.with_actual(CertificateType)
  end

  def certificate_type
    certificate_types(reload: true).first
  end

  def id
    "#{certificate_type_code}#{certificate_code}"
  end

  delegate :description, to: :certificate_description
end
