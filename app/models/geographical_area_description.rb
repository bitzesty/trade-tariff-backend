class GeographicalAreaDescription < ActiveRecord::Base
  set_primary_keys :geographical_area_description_period_sid, :geographical_area_sid

  belongs_to :geographical_area_description_period, foreign_key: :geographical_area_description_period_sid
  belongs_to :language
  belongs_to :geographical_area, foreign_key: :geographical_area_sid
end

# == Schema Information
#
# Table name: geographical_area_descriptions
#
#  record_code                              :string(255)
#  subrecord_code                           :string(255)
#  record_sequence_number                   :string(255)
#  geographical_area_description_period_sid :integer(4)
#  language_id                              :string(255)
#  geographical_area_sid                    :integer(4)
#  geographical_area_id                     :string(255)
#  description                              :text
#  created_at                               :datetime
#  updated_at                               :datetime
#

