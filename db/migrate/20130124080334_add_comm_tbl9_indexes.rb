Sequel.migration do
  up do
    alter_table :chief_tbl9 do
      add_index :tbl_type, name: :tbl_type_index
      add_index :tbl_code, name: :tbl_code_index
    end

    alter_table :chief_comm do
      add_index :cmdty_code, name: :cmdty_code_index
      add_index :uoq_code_cdu2, name: :uoq_code_cdu2_index
      add_index :uoq_code_cdu3, name: :uoq_code_cdu3_index
    end
  end

  down do
    alter_table :chief_tbl9 do
      drop_index :tbl_type, name: :tbl_type_index
      drop_index :tbl_code, name: :tbl_code_index
    end

    alter_table :chief_comm do
      drop_index :cmdty_code, name: :cmdty_code_index
      drop_index :uoq_code_cdu2, name: :uoq_code_cdu2_index
      drop_index :uoq_code_cdu3, name: :uoq_code_cdu3_index
    end
  end
end
