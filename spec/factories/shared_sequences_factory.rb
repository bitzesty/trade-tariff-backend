FactoryBot.define do
  sequence(:measurement_unit_qualifier_code, LoopingSequence.lower_a_to_upper_z, &:value)
  sequence(:additional_code_type_id, LoopingSequence.lower_a_to_upper_z, &:value)
end
