class MeasurementUnitQualifierDescription < Sequel::Model
  plugin :oplog, primary_key: :measurement_unit_qualifier_code
  set_primary_key :measurement_unit_qualifier_code
end


