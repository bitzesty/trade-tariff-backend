Sequel.migration do
  up do
    alter_table :measures do
      add_column :tariff_measure_number, String, size: 10
    end
  end

  down do
    alter_table :measures do
      drop_column :tariff_measure_number
    end
  end
end
