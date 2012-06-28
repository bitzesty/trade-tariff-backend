class MeasureConditionCode < ActiveRecord::Base
  self.primary_key = :condition_code

  has_one :description, class_name: 'MeasureConditionCodeDescription',
                        foreign_key: :condition_code
end
