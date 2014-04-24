Sequel.migration do
  change do
    alter_table :tariff_updates do
      add_column :filesize, Integer
      add_column :applied_at, DateTime
    end
  end
end
