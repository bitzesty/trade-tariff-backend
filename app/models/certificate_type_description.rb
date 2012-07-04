class CertificateTypeDescription < ActiveRecord::Base
  set_primary_keys :certificate_type_code

  belongs_to :certificate_type, foreign_key: :certificate_type_code
  belongs_to :language
end

# == Schema Information
#
# Table name: certificate_type_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  certificate_type_code  :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

