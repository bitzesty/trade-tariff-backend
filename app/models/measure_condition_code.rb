class MeasureConditionCode < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: :condition_code
  plugin :conformance_validator

  set_primary_key [:condition_code]

  one_to_one :measure_condition_code_description, key: :condition_code,
                                                  primary_key: :condition_code

  delegate :description, to: :measure_condition_code_description
end


