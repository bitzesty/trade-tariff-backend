class CertificateDescriptionPeriod < Sequel::Model
  plugin :time_machine

  set_primary_key :certificate_description_period_sid

  one_to_one :certificate_description, key: :certificate_description_period_sid,
                                       primary_key: :certificate_description_period_sid

  # belongs_to :certificate_type, foreign_key: :certificate_type_code
  # belongs_to :certificate, foreign_key: [:certificate_code, :certificate_type_code]
end


