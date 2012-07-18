class MeasureTypeSeries < Sequel::Model
  set_primary_key  :measure_type_series_id

  # has_one :measure_type_series_description
  # has_many :measure_types
end

# == Schema Information
#
# Table name: measure_type_series
#
#  record_code              :string(255)
#  subrecord_code           :string(255)
#  record_sequence_number   :string(255)
#  measure_type_series_id   :string(255)
#  validity_start_date      :date
#  validity_end_date        :date
#  measure_type_combination :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#

