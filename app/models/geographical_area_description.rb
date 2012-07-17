class GeographicalAreaDescription < Sequel::Model
  set_primary_key [:geographical_area_description_period_sid, :geographical_area_sid]

  # belongs_to :geographical_area_description_period, foreign_key: :geographical_area_description_period_sid
  # belongs_to :language
  # belongs_to :geographical_area, foreign_key: :geographical_area_sid

  # scope :valid_on, ->(date) { includes(:geographical_area_description_period).
  #                             where(["geographical_area_description_periods.validity_start_date <= ? AND
  #                                     (geographical_area_description_periods.validity_end_date >= ? OR
  #                                     geographical_area_description_periods.validity_end_date IS NULL)", date, date])
  #                           }
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

