class MeasureAction < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :action_code,
                        class_name: 'MeasureActionDescription'
end
