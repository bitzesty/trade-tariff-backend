class MeasureExcludedGeographicalArea < ActiveRecord::Base
  set_primary_keys :measure_sid, :geographical_area_sid

  belongs_to :measure, foreign_key: :measure_sid
  belongs_to :excluded_geographical_area, foreign_key: :geographical_area_sid,
                                          class_name: 'GeographicalArea'
end

# == Schema Information
#
# Table name: measure_excluded_geographical_areas
#
#  record_code                :string(255)
#  subrecord_code             :string(255)
#  record_sequence_number     :string(255)
#  measure_sid                :integer(4)
#  excluded_geographical_area :string(255)
#  geographical_area_sid      :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

