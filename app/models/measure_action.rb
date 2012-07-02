class MeasureAction < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :description, foreign_key: :action_code,
                        class_name: 'MeasureActionDescription'
end
