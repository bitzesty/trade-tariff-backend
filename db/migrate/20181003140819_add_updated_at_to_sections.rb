Sequel.migration do
  change do
    alter_table :sections do
      add_column :updated_at, DateTime, null: false, if_not_exists: true
    end
  end
end
