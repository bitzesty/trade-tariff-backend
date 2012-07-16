class GeographicalArea < ActiveRecord::Base
  self.primary_keys =  :geographical_area_sid

  has_many :geographical_area_memberships, foreign_key: :geographical_area_sid
  has_many :geographical_area_groups, through: :geographical_area_memberships,
                                      class_name: 'GeographicalArea'
  has_many :geographical_area_description_periods, foreign_key: :geographical_area_sid
  has_many :geographical_area_descriptions, through: :geographical_area_description_periods

  has_many   :children_geographical_areas, primary_key: :geographical_area_sid,
                                           foreign_key: :parent_geographical_area_group_sid,
                                           class_name: 'GeographicalArea'
  belongs_to :parent_geographical_area, foreign_key: :parent_geographical_area_group_sid,
                                        class_name: 'GeographicalArea'
  has_many :measures, foreign_key: :geographical_area_sid
  has_many :measure_excluded_geographical_areas, foreign_key: :geographical_area_sid
  has_many :excluded_measures, through: :measure_excluded_geographical_areas,
                               source: :measure
  has_many :quota_order_number_origins, foreign_key: :geographical_area_sid
  has_many :quota_order_numbers, through: :quota_order_number_origins
  has_many :quota_order_number_origin_exclusions, foreign_key: :excluded_geographical_area_sid
  has_many :excluded_quota_order_number_origins, through: :quota_order_number_origin_exclusions,
                                                 source: :quota_order_number_origin

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

