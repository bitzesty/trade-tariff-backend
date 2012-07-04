class MeasureTypeSeries < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  has_many :measure_type_series_descriptions
end
