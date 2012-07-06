class CertificateType < ActiveRecord::Base
  self.primary_keys =  :certificate_type_code

  has_one  :certificate_type_description, foreign_key: :certificate_type_code
  has_many :certificates, foreign_key: :certificate_type_code
  has_many :measure_conditions, foreign_key: :certificate_type_code
end

# == Schema Information
#
# Table name: certificate_types
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  certificate_type_code  :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

