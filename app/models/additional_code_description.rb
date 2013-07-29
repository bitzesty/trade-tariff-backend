class AdditionalCodeDescription < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:additional_code_description_period_sid, :additional_code_sid]
  plugin :conformance_validator

  set_primary_key [:additional_code_description_period_sid, :additional_code_sid]

  # one_to_one :additional_code_description_period, key: [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id]

  # many_to_one :language
  # many_to_one :additional_code_type, key: :additional_code_type_id
  # many_to_one :additional_code, key: :additional_code_sid
end


