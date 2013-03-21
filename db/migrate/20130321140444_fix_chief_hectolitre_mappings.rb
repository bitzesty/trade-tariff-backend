Sequel.migration do
  up do
    run "UPDATE measure_components_oplog SET measurement_unit_code='HLT', measurement_unit_qualifier_code=NULL WHERE measurement_unit_code='ASX' AND measurement_unit_qualifier_code = 'X'"
  end

  down do
    # this is not reversible and should not be
  end
end
