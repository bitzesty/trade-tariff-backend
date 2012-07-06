class MeursingHeading < ActiveRecord::Base
  self.primary_keys =  :meursing_table_plan_id, :meursing_heading_number, :row_column_code

  belongs_to :meursing_table_plan
  has_many :meursing_subheadings, foreign_key: [:meursing_table_plan_id,
                                                :meursing_heading_number]
  has_one :meursing_heading, foreign_key: [:meursing_table_plan_id,
                                           :meursing_heading_number]
end

# == Schema Information
#
# Table name: meursing_headings
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  meursing_table_plan_id  :string(255)
#  meursing_heading_number :integer(4)
#  row_column_code         :integer(4)
#  validity_start_date     :date
#  validity_end_date       :date
#  created_at              :datetime
#  updated_at              :datetime
#

