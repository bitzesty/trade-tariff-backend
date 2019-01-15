class MeursingAdditionalCode < Sequel::Model
  plugin :oplog, primary_key: :meursing_additional_code_sid
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:meursing_additional_code_sid]
end
