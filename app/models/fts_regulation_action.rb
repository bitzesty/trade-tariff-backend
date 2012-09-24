class FtsRegulationAction < Sequel::Model
  set_primary_key [:fts_regulation_id, :fts_regulation_role,
                   :stopped_regulation_id, :stopped_regulation_role]
end


