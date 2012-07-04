class MeasureType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :measure_type_id,
                        class_name: 'MeasureTypeDescription'
  has_many :measures, foreign_key: :measure_type
end
