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

# == Schema Information
#
# Table name: certificates
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  certificate_type_code  :string(255)
#  certificate_code       :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

