class MeasurementUnit < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :description, foreign_key: :measurement_unit_code,
                        class_name: 'MeasurementUnitDescription'
  has_one :measurement, foreign_key: :measurement_unit_code
  has_many :quota_definitions, foreign_key: :measurement_unit_code
end
