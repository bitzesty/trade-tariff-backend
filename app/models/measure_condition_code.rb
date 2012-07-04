class MeasureConditionCode < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number

  has_one :description, class_name: 'MeasureConditionCodeDescription',
                        foreign_key: :condition_code
end
