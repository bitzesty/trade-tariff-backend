Sequel.migration do
  change do
    alter_table :chief_comm do
      add_column :origin, String, size: 30
    end
  end
end
