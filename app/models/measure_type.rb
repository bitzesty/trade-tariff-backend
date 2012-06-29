class MeasureType < ActiveRecord::Base
  self.primary_key = :measure_type_id

  has_one :description, foreign_key: :measure_type_id,
                        class_name: 'MeasureTypeDescription'
  has_many :measures, foreign_key: :measure_type
end
