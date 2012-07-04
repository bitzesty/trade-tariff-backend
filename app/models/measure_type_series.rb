class MeasureTypeSeries < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :measure_type_series_descriptions
end
