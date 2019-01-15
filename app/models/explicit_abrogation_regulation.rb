class ExplicitAbrogationRegulation < Sequel::Model
  plugin :oplog, primary_key: %i[oid explicit_abrogation_regulation_id explicit_abrogation_regulation_role]
  plugin :conformance_validator

  set_primary_key %i[explicit_abrogation_regulation_id explicit_abrogation_regulation_role]
end
