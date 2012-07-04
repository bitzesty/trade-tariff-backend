class MeursingSubheading < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :meursing_table_plan
end

# == Schema Information
#
# Table name: meursing_subheadings
#
#  record_code                :string(255)
#  subrecord_code             :string(255)
#  record_sequence_number     :string(255)
#  meursing_table_plan_id     :string(255)
#  meursing_heading_number    :integer(4)
#  row_column_code            :integer(4)
#  subheading_sequence_number :integer(4)
#  validity_start_date        :date
#  validity_end_date          :date
#  description                :text
#  created_at                 :datetime
#  updated_at                 :datetime
#

