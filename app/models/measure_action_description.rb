class MeasureActionDescription < Sequel::Model
  plugin :oplog, primary_key: :action_code
  plugin :conformance_validator

  set_primary_key [:action_code]
end


