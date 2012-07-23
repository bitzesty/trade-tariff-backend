class Certificate < Sequel::Model
  plugin :time_machine

  set_primary_key [:certificate_code, :certificate_type_code]

  one_to_one :certificate_description, primary_key: {}, key: {}, dataset: -> {
    CertificateDescription.with_actual(CertificateDescriptionPeriod)
                          .join(:certificate_description_periods, certificate_description_periods__certificate_description_period_sid: :certificate_descriptions__certificate_description_period_sid,
                                                                  certificate_description_periods__certificate_type_code: :certificate_descriptions__certificate_type_code,
                                                                  certificate_description_periods__certificate_code: :certificate_descriptions__certificate_code)
                          .where(certificate_description_periods__certificate_code: certificate_code,
                                 certificate_description_periods__certificate_type_code: certificate_type_code)
                          .order(:certificate_description_periods__validity_start_date.desc)
  }
end


