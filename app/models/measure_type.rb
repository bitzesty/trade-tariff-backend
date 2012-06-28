class MeasureType < ActiveRecord::Base
  self.primary_key = :measure_type_id

  has_one :description
end
