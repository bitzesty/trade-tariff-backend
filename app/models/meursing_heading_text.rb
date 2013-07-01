class MeursingHeadingText < Sequel::Model
  plugin :oplog, primary_key: [:meursing_table_plan_id,
                               :meursing_heading_number,
                               :row_column_code]
  set_primary_key [:meursing_table_plan_id, :meursing_heading_number, :row_column_code]
end


