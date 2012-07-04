class CertificateDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :certificate_description_period_sid

  belongs_to :certificate_type, foreign_key: :certificate_type_code
  belongs_to :certificate, foreign_key: [:certificate_code, :certificate_type_code]
end

# == Schema Information
#
# Table name: certificate_description_periods
#
#  record_code                        :string(255)
#  subrecord_code                     :string(255)
#  record_sequence_number             :string(255)
#  certificate_description_period_sid :string(255)
#  certificate_type_code              :string(255)
#  certificate_code                   :string(255)
#  validity_start_date                :date
#  created_at                         :datetime
#  updated_at                         :datetime
#

