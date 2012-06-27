class DutyExpressionDescription < ActiveRecord::Base
  belongs_to :duty_expression, foreign_key: :duty_expression_id
end
