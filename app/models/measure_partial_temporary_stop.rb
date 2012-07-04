class MeasurePartialTemporaryStop < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :measure, foreign_key: :measure_sid
  # TODO FIXME
  # belongs_to :base_regulation, foreign_key: [:abrogation_regulation_id]
  # belongs_to :base_regulation, foreign_key: [:partial_temporary_stop_regulation_id]
end

# == Schema Information
#
# Table name: measure_partial_temporary_stops
#
#  record_code                                              :string(255)
#  subrecord_code                                           :string(255)
#  record_sequence_number                                   :string(255)
#  measure_sid                                              :integer(4)
#  validity_start_date                                      :date
#  validity_end_date                                        :date
#  partial_temporary_stop_regulation_id                     :string(255)
#  partial_temporary_stop_regulation_officialjournal_number :string(255)
#  partial_temporary_stop_regulation_officialjournal_page   :integer(4)
#  abrogation_regulation_id                                 :string(255)
#  abrogation_regulation_officialjournal_number             :string(255)
#  abrogation_regulation_officialjournal_page               :integer(4)
#  created_at                                               :datetime
#  updated_at                                               :datetime
#

