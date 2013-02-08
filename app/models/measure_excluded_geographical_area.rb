class MeasureExcludedGeographicalArea < Sequel::Model
  plugin :oplog, primary_key: [:measure_sid, :geographical_area_sid]
  set_primary_key :measure_sid, :geographical_area_sid
end
