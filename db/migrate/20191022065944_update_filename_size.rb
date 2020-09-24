Sequel.migration do
  up do
    alter_table :tariff_updates do
      set_column_type :filename, String, size: 255
    end
  end

  down do
    alter_table :tariff_updates do
      set_column_type :filename, String, size: 30
    end
  end
end
