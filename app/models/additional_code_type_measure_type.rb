class AdditionalCodeTypeMeasureType < Sequel::Model
  plugin :oplog, primary_key: %i[measure_type_id additional_code_type_id]
  plugin :conformance_validator

  set_primary_key %i[measure_type_id additional_code_type_id]

  many_to_one :measure_type
  many_to_one :additional_code_type
end
