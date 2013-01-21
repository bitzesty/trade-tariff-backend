Sequel.migration do
  up do
    create_table(:national_measurement_units) do
      String :measurement_unit_code, :size=>3
      String :description, size: 100

      index [:measurement_unit_code], :name=>:primary_key, :unique=>true
    end

    run "INSERT INTO national_measurement_units VALUES('070', 'Standard Litres')"
  end

  down do
    drop_table(:national_measurement_units)
  end
end
