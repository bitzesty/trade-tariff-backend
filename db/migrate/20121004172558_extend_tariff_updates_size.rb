Sequel.migration do
  up do
    alter_table :tariff_updates do
      set_column_type :update_type, String, size: 50
    end
  end

  down do
    alter_table :tariff_updates do
      set_column_type :update_type, String, size: 15
    end
  end
end
