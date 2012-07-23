class FootnoteAssociationMeursingHeading < Sequel::Model
  set_primary_key [:footnote_id, :meursing_table_plan_id]

  # belongs_to :meursing_table_plan
  # belongs_to :footnote
end


