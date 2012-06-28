class RegulationRoleTypeDescription < ActiveRecord::Base
  belongs_to :regulation_role_type
  belongs_to :language
end
