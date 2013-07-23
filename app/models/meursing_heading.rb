class MeursingHeading < Sequel::Model
  plugin :oplog, primary_key: [:meursing_table_plan_id,
                               :meursing_heading_number,
                               :row_column_code]
  plugin :conformance_validator

  set_primary_key [:meursing_table_plan_id, :meursing_heading_number, :row_column_code]
end


