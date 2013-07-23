class MeasurementUnitDescription < Sequel::Model
  plugin :oplog, primary_key: :measurement_unit_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code]
end


