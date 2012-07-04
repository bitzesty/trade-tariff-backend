class RegulationRoleTypeDescription < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code
  
  belongs_to :regulation_role_type
  belongs_to :language
end
