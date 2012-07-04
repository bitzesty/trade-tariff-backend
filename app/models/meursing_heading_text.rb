class MeursingHeadingText < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code, :record_sequence_number
  
  belongs_to :meursing_table_plan
  belongs_to :language
end
