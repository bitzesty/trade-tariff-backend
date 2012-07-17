class CertificateDescription < Sequel::Model
  set_primary_key :certificate_description_period_sid

  # belongs_to :certificate_description_period, foreign_key: :certificate_description_period_sid
  # belongs_to :certificate_type, foreign_key: :certificate_type_code
  # belongs_to :certificate, foreign_key: [:certificate_code, :certificate_type_code]
  # belongs_to :language
end

# == Schema Information
#
# Table name: certificate_descriptions
#
#  record_code                        :string(255)
#  subrecord_code                     :string(255)
#  record_sequence_number             :string(255)
#  certificate_description_period_sid :string(255)
#  language_id                        :string(255)
#  certificate_type_code              :string(255)
#  certificate_code                   :string(255)
#  description                        :text
#  created_at                         :datetime
#  updated_at                         :datetime
#

