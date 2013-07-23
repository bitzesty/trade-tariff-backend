class MeursingTablePlan < Sequel::Model
  plugin :oplog, primary_key: :meursing_table_plan_id
  plugin :conformance_validator

  set_primary_key [:meursing_table_plan_id]
end


