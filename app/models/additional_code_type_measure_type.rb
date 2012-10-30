class AdditionalCodeTypeMeasureType < Sequel::Model
  set_primary_key [:measure_type_id, :additional_code_type_id]

  many_to_one :measure_type
  many_to_one :additional_code_type

  ######### Conformance validations 240
  validates do
    # AMT1, AMT2
    presence_of [:measure_type_id, :additional_code_type_id]
    # AMT3
    uniqueness_of [:measure_type_id, :additional_code_type_id]
    # AMT5
    validity_dates
    # TODO: AMT4
    # TODO: AMT7
  end
end


