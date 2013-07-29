class FtsRegulationAction < Sequel::Model
  plugin :oplog, primary_key: [:fts_regulation_id,
                               :fts_regulation_role,
                               :stopped_regulation_id,
                               :stopped_regulation_role]
  plugin :conformance_validator

  set_primary_key [:fts_regulation_id, :fts_regulation_role,
                   :stopped_regulation_id, :stopped_regulation_role]
end


