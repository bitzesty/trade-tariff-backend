Sequel.migration do
  change do
    create_table :measurement_unit_abbreviations do
      primary_key :id
      String :abbreviation
      String :measurement_unit_code
      String :measurement_unit_qualifier

      index [:measurement_unit_code, :measurement_unit_qualifier],
        name: :measurement_unit_code_qualifier
    end
  end
end
