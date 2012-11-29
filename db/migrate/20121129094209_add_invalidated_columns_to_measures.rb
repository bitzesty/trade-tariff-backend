Sequel.migration do
  change do
    alter_table :measures do
      add_column :invalidated_by, Integer
      add_column :invalidated_at, DateTime
    end
  end
end
