class Certificate < Sequel::Model
  plugin :time_machine

  set_primary_key [:certificate_code, :certificate_type_code]

  one_to_one :certificate_description, primary_key: {}, key: {}, dataset: -> {
    CertificateDescriptionPeriod.actual
                                .where(certificate_code: certificate_code,
                                       certificate_type_code: certificate_type_code)
                                .order(:validity_start_date.desc)
                                .first
                                .certificate_description_dataset
  }

  # belongs_to :certificate_type, foreign_key: :certificate_type_code
  # has_many :certificate_description_periods, foreign_key: [:certificate_code,
  #                                                          :certificate_type_code]
  # has_many :certificate_descriptions, through: :certificate_description_periods,
  #                                     source: :certificate
  # has_many :measure_conditions, foreign_key: [:certificate_code,
  #                                             :certificate_type_code]
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

