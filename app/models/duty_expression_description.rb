class DutyExpressionDescription < Sequel::Model
  set_primary_key :duty_expression_id

  # belongs_to :duty_expression, foreign_key: :duty_expression_id
  # belongs_to :language
end


