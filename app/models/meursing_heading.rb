class MeursingHeading < Sequel::Model
  set_primary_key  :meursing_table_plan_id, :meursing_heading_number, :row_column_code

  # belongs_to :meursing_table_plan
  # has_many :meursing_subheadings, foreign_key: [:meursing_table_plan_id,
  #                                               :meursing_heading_number]
  # has_one :meursing_heading, foreign_key: [:meursing_table_plan_id,
  #                                          :meursing_heading_number]
end


