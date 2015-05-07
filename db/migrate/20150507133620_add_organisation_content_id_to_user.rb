Sequel.migration do
  change do
    alter_table :users do
      add_column :organisation_content_id, String
    end
  end
end
