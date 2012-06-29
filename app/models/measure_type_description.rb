class MeasureTypeDescription < ActiveRecord::Base
  belongs_to :measure_type
  belongs_to :language
end
