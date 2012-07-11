class MeursingTableCellComponent < ActiveRecord::Base
  self.primary_keys =  [:meursing_table_plan_id, :heading_number,
                        :row_column_code, :meursing_additional_code_sid]

  belongs_to :meursing_additional_code, foreign_key: :meursing_additional_code_sid
  belongs_to :meursing_table_plan
end

# == Schema Information
#
# Table name: meursing_table_cell_components
#
#  record_code                  :string(255)
#  subrecord_code               :string(255)
#  record_sequence_number       :string(255)
#  meursing_additional_code_sid :integer(4)
#  meursing_table_plan_id       :string(255)
#  heading_number               :integer(4)
#  row_column_code              :integer(4)
#  subheading_sequence_number   :integer(4)
#  validity_start_date          :date
#  validity_end_date            :date
#  additional_code              :integer(4)
#  created_at                   :datetime
#  updated_at                   :datetime
#

