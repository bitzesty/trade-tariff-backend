class MeasurementUnitQualifierDescription < ActiveRecord::Base
  self.primary_keys =  :measurement_unit_qualifier_code

  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :language
end

# == Schema Information
#
# Table name: measurement_unit_qualifier_descriptions
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  measurement_unit_qualifier_code :string(255)
#  language_id                     :string(255)
#  description                     :text
#  created_at                      :datetime
#  updated_at                      :datetime
#

