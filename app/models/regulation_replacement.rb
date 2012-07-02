class RegulationReplacement < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :geographical_area
  belongs_to :replacing_regulation, foreign_key: [:replacing_regulation_role,
                                                  :replacing_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :replaced_regulation, foreign_key: [:replaced_regulation_role,
                                                 :replaced_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :measure_type

end
