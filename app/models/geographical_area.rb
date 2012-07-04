class GeographicalArea < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  has_many :geographical_area_memberships
  has_many :geographical_area_description_periods, foreign_key: :geographical_area_sid
  has_many :geographical_area_description, foreign_key: :geographical_area_sid
  has_many :measure_excluded_geographical_areas, foreign_key: :geographical_area_sid

  belongs_to :geographical_area, foreign_key: :parent_geographical_area_group_sid,
                                 class_name: 'GeographicalArea'
  has_many :geographical_areas, foreign_key: :parent_geographical_area_group_sid,
                                class_name: 'GeographicalArea'
  has_many :regulation_replacements, foreign_key: :geographical_area_id
  # has_many :excluded_measures, through: :measure_excluded_geographical_areas,
  #                              class_name: 'Measure'
end
