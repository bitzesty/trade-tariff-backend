class MeursingSubheading < Sequel::Model
  set_primary_key  :meursing_table_plan_id, :meursing_heading_number, :row_column_code,
                   :subheading_sequence_number
end


