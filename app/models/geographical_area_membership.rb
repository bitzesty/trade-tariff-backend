class GeographicalAreaMembership < ActiveRecord::Base
  set_primary_keys :geographical_area_sid, :geographical_area_group_sid

  belongs_to :geographical_area, foreign_key: :geographical_area_sid
  belongs_to :geographical_area_group, foreign_key: :geographical_area_group_sid,
                                       class_name: 'GeographicalArea'
end

# == Schema Information
#
# Table name: geographical_area_memberships
#
#  record_code                 :string(255)
#  subrecord_code              :string(255)
#  record_sequence_number      :string(255)
#  geographical_area_sid       :integer(4)
#  geographical_area_group_sid :integer(4)
#  validity_start_date         :date
#  validity_end_date           :date
#  created_at                  :datetime
#  updated_at                  :datetime
#

