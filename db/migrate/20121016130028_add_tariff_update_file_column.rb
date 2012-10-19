Sequel.migration do
  up do
    alter_table :tariff_updates do
      add_column :file, :longblob
    end
  end

  down do
    alter_table :tariff_updates do
      drop_column :file
    end
  end
end
