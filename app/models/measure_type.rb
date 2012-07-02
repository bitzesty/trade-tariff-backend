class MeasureType < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :description, foreign_key: :measure_type_id,
                        class_name: 'MeasureTypeDescription'
  has_many :measures, foreign_key: :measure_type
end
