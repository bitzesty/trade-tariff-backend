class GeographicalArea < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

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

# == Schema Information
#
# Table name: geographical_areas
#
#  record_code                        :string(255)
#  subrecord_code                     :string(255)
#  record_sequence_number             :string(255)
#  geographical_area_sid              :integer(4)
#  parent_geographical_area_group_sid :integer(4)
#  validity_start_date                :date
#  validity_end_date                  :date
#  geographical_code                  :string(255)
#  geographical_area_id               :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#

