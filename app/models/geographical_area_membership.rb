class GeographicalAreaMembership < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :geographical_area, foreign_key: :geographical_area_sid
  belongs_to :geographical_area_group, foreign_key: :geographical_area_group_sid,
                                       class_name: 'GeographicalArea'
end
