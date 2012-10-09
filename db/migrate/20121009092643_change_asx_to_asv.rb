Sequel.migration do
  up do
    run "UPDATE measure_components SET measurement_unit_code = 'ASV' WHERE measurement_unit_code = 'ASX'"
  end

  down do
    run "UPDATE measure_components SET measurement_unit_code = 'ASX' WHERE measurement_unit_code = 'ASV'"
  end
end
