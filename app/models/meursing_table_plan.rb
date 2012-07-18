class MeursingTablePlan < Sequel::Model
  set_primary_key  :meursing_table_plan_id

  # has_many :meursing_table_cell_components
  # has_many :meursing_headings
  # has_many :meursing_subheadings
  # has_many :meursing_heading_texts
  # has_many :additional_code_types
  # has_many :footnote_association_meursing_headings
  # has_many :footnotes, through: :footnote_association_meursing_headings
end

# == Schema Information
#
# Table name: meursing_table_plans
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  meursing_table_plan_id :string(255)
#  validity_start_date    :date
#  validity_end_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

