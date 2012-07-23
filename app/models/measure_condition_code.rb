class MeasureConditionCode < Sequel::Model
  set_primary_key :condition_code

  one_to_one :measure_condition_code_description, key: [:condition_code],
                                                  primary_key: [:condition_code]
end


