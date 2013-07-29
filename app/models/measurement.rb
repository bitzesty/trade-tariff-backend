class Measurement < Sequel::Model
  plugin :oplog, primary_key: [:measurement_unit_code,
                               :measurement_unit_qualifier_code]
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code, :measurement_unit_qualifier_code]
end
