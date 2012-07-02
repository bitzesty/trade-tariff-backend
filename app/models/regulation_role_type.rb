class RegulationRoleType < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_one :description, foreign_key: :regulation_role_type_id,
                        class_name: 'RegulationRoleTypeDescription'
end
