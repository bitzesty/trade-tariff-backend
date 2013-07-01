class DutyExpressionDescription < Sequel::Model
  set_primary_key [:duty_expression_id]
  plugin :oplog, primary_key: :duty_expression_id
end


