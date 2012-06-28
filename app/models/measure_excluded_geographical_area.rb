class MeasureExcludedGeographicalArea < ActiveRecord::Base
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :geographical_area, foreign_key: :geographical_area_sid
end
