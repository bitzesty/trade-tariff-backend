class MeasureTypeSeriesDescription < ActiveRecord::Base
  belongs_to :measure_type_series
  belongs_to :language
end
