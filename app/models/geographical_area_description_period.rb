class GeographicalAreaDescriptionPeriod < ActiveRecord::Base
  self.primary_keys =  :geographical_area_description_period_sid

  belongs_to :geographical_area, foreign_key: :geographical_area_sid
  belongs_to :geographical_area_description, foreign_key: [:geographical_area_description_period_sid,
                                                           :geographical_area_sid]
end

# == Schema Information
#
# Table name: geographical_area_description_periods
#
#  record_code                              :string(255)
#  subrecord_code                           :string(255)
#  record_sequence_number                   :string(255)
#  geographical_area_description_period_sid :integer(4)
#  geographical_area_sid                    :integer(4)
#  validity_start_date                      :date
#  geographical_area_id                     :string(255)
#  created_at                               :datetime
#  updated_at                               :datetime
#

