class RegulationRoleTypeDescription < Sequel::Model
  plugin :oplog, primary_key: :regulation_role_type_id
  plugin :conformance_validator

  set_primary_key [:regulation_role_type_id]
end


