class MeasureExcludedGeographicalArea < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :geographical_area, foreign_key: :geographical_area_sid
end
