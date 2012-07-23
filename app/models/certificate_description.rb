class CertificateDescription < Sequel::Model
  plugin :time_machine

  set_primary_key :certificate_description_period_sid
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

