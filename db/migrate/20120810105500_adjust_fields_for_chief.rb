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
      # drop_index [:replacing_regulation_id, :replacing_regulation_role, :replaced_regulation_id, :replaced_regulation_role, :measure_type_id, :geographical_area_id, :chapter_heading], :name=>:primary_key

      set_column_type :measure_type_id, String, size: 3

      add_index [:replacing_regulation_id, :replacing_regulation_role], name: 'replacing_regulation'
      add_index [:replaced_regulation_id, :replaced_regulation_role], name: 'replaced_regulation'
      add_index :measure_type_id, name: 'measure_type'
      add_index :geographical_area_id, name: 'geographical_area'
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
      drop_index [:replacing_regulation_id, :replacing_regulation_role], name: 'replacing_regulation'
      drop_index [:replaced_regulation_id, :replaced_regulation_role], name: 'replaced_regulation'
      drop_index :measure_type_id, name: 'measure_type'
      drop_index :geographical_area_id, name: 'geographical_area'

      set_column_type :measure_type_id, Integer

      add_index [:replacing_regulation_id, :replacing_regulation_role, :replaced_regulation_id, :replaced_regulation_role, :measure_type_id, :geographical_area_id, :chapter_heading], :name=>:primary_key, :unique=>true
    end
  end
end
