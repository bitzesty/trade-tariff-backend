Sequel.migration do
  up do
    alter_table :additional_code_type_measure_types_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :chief_measure_type_adco do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :chief_measure_type_footnote do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :measure_type_descriptions_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :measure_types_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :measures_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :regulation_replacements_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
  end

  down do
    alter_table :additional_code_type_measure_types_oplog do
      set_column_type :measure_type_id, String, size: 3
    end
    alter_table :chief_measure_type_adco do
      set_column_type :measure_type_id, String, size: 3
    end
    alter_table :chief_measure_type_footnote do
      set_column_type :measure_type_id, String, size: 3
    end
    alter_table :measure_type_descriptions_oplog do
      set_column_type :measure_type_id, String, size: 6
    end
    alter_table :measure_types_oplog do
      set_column_type :measure_type_id, String, size: 3
    end
    alter_table :measures_oplog do
      set_column_type :measure_type_id, String, size: 3
    end
    alter_table :regulation_replacements_oplog do
      set_column_type :measure_type_id, String, size: 3
    end
  end
end
