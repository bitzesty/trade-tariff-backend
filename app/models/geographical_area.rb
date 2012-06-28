class GeographicalArea < ActiveRecord::Base
  self.primary_key = :geographical_area_sid

  has_many :geographical_area_memberships
  has_many :geographical_area_description_periods
  has_many :geographical_area_description
  has_many :measure_excluded_geographical_areas
  has_many :excluded_measures, through: :measure_excluded_geographical_areas,
                               class_name: 'Measure'
end
