class RegulationReplacement < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :geographical_area
  belongs_to :replacing_regulation, foreign_key: [:replacing_regulation_role,
                                                  :replacing_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :replaced_regulation, foreign_key: [:replaced_regulation_role,
                                                 :replaced_regulation_id],
                                    class_name: 'BaseRegulation'
  belongs_to :measure_type

end
