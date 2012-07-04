class GeographicalAreaDescriptionPeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  # TODO does it map by geographical_area_id or geographical_area_sid???
  belongs_to :geographical_area, primary_key: :geographical_area_sid
end
