class GeographicalAreaDescriptionPeriod < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  # TODO does it map by geographical_area_id or geographical_area_sid???
  belongs_to :geographical_area, primary_key: :geographical_area_sid
end
