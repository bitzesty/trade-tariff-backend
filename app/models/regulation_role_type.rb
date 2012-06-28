class RegulationRoleType < ActiveRecord::Base
  self.primary_key = :regulation_role_type_id

  has_one :regulation_role_tpe_description
end
