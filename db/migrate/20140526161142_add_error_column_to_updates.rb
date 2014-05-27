Sequel.migration do
  change do
    alter_table :tariff_updates do
      add_column :last_error, String, text: true
      add_column :last_error_at, Time
    end
  end
end
