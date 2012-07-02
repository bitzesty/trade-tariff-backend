class MeursingSubheading < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :meursing_table_plan
end
