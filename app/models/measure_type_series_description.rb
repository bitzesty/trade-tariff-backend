class MeasureTypeSeriesDescription < Sequel::Model
  plugin :oplog, primary_key: :measure_type_series_id
  plugin :conformance_validator

  set_primary_key [:measure_type_series_id]
end


