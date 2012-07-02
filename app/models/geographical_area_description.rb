class GeographicalAreaDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :geographical_area_description_period, foreign_key: :geographical_area_description_period_sid
  belongs_to :language
  belongs_to :geographical_area, foreign_key: :geographical_area_sid
end
