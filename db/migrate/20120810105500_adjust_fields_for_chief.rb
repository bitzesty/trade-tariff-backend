Sequel.migration do
  up do
    alter_table :measure_types do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :additional_code_type_measure_types do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :measure_type_descriptions do
      set_column_type :measure_type_id, String, size: 3
    end

    alter_table :measures do
      set_column_type :measure_type, String, size: 3
    end

    alter_table :regulation_replacements do
      set_column_type :measure_type_id, String, size: 3
    end
  end

  down do
    alter_table :measure_types do
      set_column_type :measure_type_id, Integer
    end

    alter_table :additional_code_type_measure_types do
      set_column_type :measure_type_id, String
    end

    alter_table :measure_type_descriptions do
      set_column_type :measure_type_id, Integer
    end

    alter_table :measures do
      set_column_type :measure_type, Integer
    end

    alter_table :regulation_replacements do
      set_column_type :measure_type_id, Integer
    end
  end
end
