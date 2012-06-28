class MeursingTablePlan < ActiveRecord::Base
  self.primary_key = :meursing_table_plan_id

  has_many :meursing_table_cell_components
  has_many :meursing_headings
  has_many :meursing_subheadings
  has_many :meursing_heading_texts
  has_many :additional_code_types
  has_many :footnote_association_meursing_headings
  has_many :footnotes, through: :footnote_association_meursing_headings
end
