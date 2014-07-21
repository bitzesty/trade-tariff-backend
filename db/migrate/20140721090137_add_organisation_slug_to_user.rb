Sequel.migration do
  change do
    alter_table :users do
      add_column :organisation_slug, String
    end
  end
end
