class MeasureExcludedGeographicalArea < Sequel::Model
  plugin :oplog, primary_key: [:measure_sid, :geographical_area_sid]
  plugin :conformance_validator

  set_primary_key [:measure_sid, :geographical_area_sid]
end
