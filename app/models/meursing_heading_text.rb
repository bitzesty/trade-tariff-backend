class MeursingHeadingText < ActiveRecord::Base
  self.primary_keys =  :meursing_table_plan_id, :meursing_heading_number

  belongs_to :meursing_table_plan
  belongs_to :meursing_heading, foreign_key: [:meursing_table_plan_id,
                                              :meursing_heading_number,
                                              :row_column_code]
  belongs_to :language
end

# == Schema Information
#
# Table name: meursing_heading_texts
#
#  record_code             :string(255)
#  subrecord_code          :string(255)
#  record_sequence_number  :string(255)
#  meursing_table_plan_id  :string(255)
#  meursing_heading_number :integer(4)
#  row_column_code         :integer(4)
#  language_id             :string(255)
#  description             :text
#  created_at              :datetime
#  updated_at              :datetime
#

