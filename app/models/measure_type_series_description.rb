class MeasureTypeSeriesDescription < Sequel::Model
  set_primary_keys  :measure_type_series_id

  # belongs_to :measure_type_series
  # belongs_to :language
end

# == Schema Information
#
# Table name: measure_type_series_descriptions
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  measure_type_series_id :string(255)
#  language_id            :string(255)
#  description            :text
#  created_at             :datetime
#  updated_at             :datetime
#

