Sequel.migration do
  change do
    create_table :data_migrations do
      Text :filename, primary_key: true, index: true, unique: true, null: false
    end
  end
end
