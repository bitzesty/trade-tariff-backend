class MeasureExcludedGeographicalArea < Sequel::Model
  set_primary_key :measure_sid, :geographical_area_sid

  # belongs_to :measure, foreign_key: :measure_sid
  # belongs_to :ref_excluded_geographical_area, foreign_key: :geographical_area_sid,
  #                                             class_name: 'GeographicalArea'
end


