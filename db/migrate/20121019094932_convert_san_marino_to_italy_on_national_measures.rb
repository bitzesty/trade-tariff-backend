Sequel.migration do
  up do
    run "UPDATE measure_excluded_geographical_areas SET geographical_area_sid = 382, excluded_geographical_area = 'SM' WHERE measure_sid < 0 AND excluded_geographical_area = 'IT';"
  end

  down do
    run "UPDATE measure_excluded_geographical_areas SET geographical_area_sid = 270, excluded_geographical_area = 'IT' WHERE measure_sid < 0 AND excluded_geographical_area = 'SM';"
  end
end
