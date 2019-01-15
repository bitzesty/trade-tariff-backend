class ProrogationRegulation < Sequel::Model
  plugin :oplog, primary_key: %i[prorogation_regulation_id
                                 prorogation_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[prorogation_regulation_id prorogation_regulation_role]
end
