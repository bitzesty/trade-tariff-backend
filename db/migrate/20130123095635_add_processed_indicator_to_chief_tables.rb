Sequel.migration do
  change do
    alter_table :chief_comm do
      add_column :processed, TrueClass
    end

    alter_table :chief_tbl9 do
      add_column :origin, String, size: 30
      add_column :processed, TrueClass
    end
  end
end
