class CompleteAbrogationRegulation < Sequel::Model
  set_primary_key [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]

  plugin :oplog, primary_key: [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role]
  plugin :conformance_validator
end


