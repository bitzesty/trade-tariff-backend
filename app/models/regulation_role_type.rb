class RegulationRoleType < Sequel::Model
  set_primary_key  :regulation_role_type_id

  one_to_one :regulation_role_type_description, key: :regulation_role_type_id,
                                                primary_key: :regulation_role_type_id

  delegate :description, to: :regulation_role_type_description
end


