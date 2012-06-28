class MeasureTypeSeries < ActiveRecord::Base
  self.primary_key = :measure_type_series_id

  has_many :measure_type_series_descriptions
end
