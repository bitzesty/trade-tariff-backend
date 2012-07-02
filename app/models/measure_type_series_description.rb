class MeasureTypeSeriesDescription < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  belongs_to :measure_type_series
  belongs_to :language
end
