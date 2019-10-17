Sequel.migration do
  change do
    alter_table :measures_oplog do
      add_column :effective_start_date, DateTime
      add_column :effective_end_date, DateTime
    end
  end
end
