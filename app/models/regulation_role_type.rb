class RegulationRoleType < ActiveRecord::Base
  self.primary_key = :regulation_role_type_id

  has_one :description, foreign_key: :regulation_role_type_id,
                        class_name: 'RegulationRoleTypeDescription'
end
