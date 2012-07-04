class RegulationRoleType < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_one :description, foreign_key: :regulation_role_type_id,
                        class_name: 'RegulationRoleTypeDescription'
end
