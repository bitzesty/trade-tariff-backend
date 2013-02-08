class ExplicitAbrogationRegulation < Sequel::Model
  set_primary_key [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role]
  plugin :oplog, primary_key: [:oid, :explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role]
end


