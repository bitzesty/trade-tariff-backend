class GeographicalAreaDescriptionPeriod < ActiveRecord::Base
  self.primary_key = :geographical_area_description_period_sid

  # belongs_to :geographical_area, primary_key: :geographical_area_sid
end
