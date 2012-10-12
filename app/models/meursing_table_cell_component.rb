class MeursingTableCellComponent < Sequel::Model
  set_primary_key  [:meursing_table_plan_id, :heading_number,
                        :row_column_code, :meursing_additional_code_sid]
end


