Sequel.migration do
  up do
    alter_table :measure_types do
      add_column :measure_type_acronym, String, size: 3
    end
  end

  down do
    alter_table :measure_types do
      drop_column :measure_type_acronym
    end
  end
end
