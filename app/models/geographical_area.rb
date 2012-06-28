class GeographicalArea < ActiveRecord::Base
  self.primary_key = :geographical_area_sid

  has_many :geographical_area_memberships
  has_many :geographical_area_description_periods
  has_many :geographical_area_description
end
