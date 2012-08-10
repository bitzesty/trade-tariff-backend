Sequel.migration do
  up do
    alter_table :certificate_description_periods do
      add_column :national, TrueClass
    end
  end

  down do
    alter_table :certificate_description_periods do
      drop_column  :national
    end
  end
end
