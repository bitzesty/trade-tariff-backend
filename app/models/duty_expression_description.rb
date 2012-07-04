class DutyExpressionDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :duty_expression, foreign_key: :duty_expression_id
  belongs_to :language
end
