class MeasureConditionCode < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :description, class_name: 'MeasureConditionCodeDescription',
                        foreign_key: :condition_code
end
