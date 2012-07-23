class MeursingHeadingText < Sequel::Model
  set_primary_key  :meursing_table_plan_id, :meursing_heading_number, :row_column_code

  # belongs_to :meursing_table_plan
  # belongs_to :meursing_heading, foreign_key: [:meursing_table_plan_id,
  #                                             :meursing_heading_number,
  #                                             :row_column_code]
  # belongs_to :language
end


