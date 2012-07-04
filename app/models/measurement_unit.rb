class MeasurementUnit < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :measurement_unit_code,
                        class_name: 'MeasurementUnitDescription'
  has_one :measurement, foreign_key: :measurement_unit_code
  has_many :quota_definitions, foreign_key: :measurement_unit_code
end

# == Schema Information
#
# Table name: measurement_units
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  measurement_unit_code  :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

