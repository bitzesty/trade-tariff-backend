class MeasureTypeSeriesDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :measure_type_series
  belongs_to :language
end
