class Chief::MeasureTypeAdco < Sequel::Model(:chief_measure_type_adco)
  set_primary_key :measure_group_code, :measure_type, :tax_type_code, :measure_type_id
end