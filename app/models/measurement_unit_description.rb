class MeasurementUnitDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  belongs_to :language
end
