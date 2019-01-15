class MeursingHeadingText < Sequel::Model
  plugin :oplog, primary_key: %i[meursing_table_plan_id
                                 meursing_heading_number
                                 row_column_code]
  plugin :conformance_validator

  set_primary_key %i[meursing_table_plan_id meursing_heading_number row_column_code]
end
