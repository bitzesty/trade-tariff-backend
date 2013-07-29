class RegulationGroupDescription < Sequel::Model
  plugin :oplog, primary_key: :regulation_group_id
  plugin :conformance_validator

  set_primary_key [:regulation_group_id]
end


