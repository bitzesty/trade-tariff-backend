class RegulationReplacement < Sequel::Model
  plugin :oplog, primary_key: [:replacing_regulation_id,
                               :replacing_regulation_role,
                               :replaced_regulation_id,
                               :replaced_regulation_role]
  plugin :conformance_validator

  set_primary_key [:replacing_regulation_id, :replacing_regulation_role,
                   :replaced_regulation_id, :replaced_regulation_role]
end


