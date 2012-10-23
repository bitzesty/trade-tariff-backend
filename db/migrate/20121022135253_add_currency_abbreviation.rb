Sequel.migration do
  up do
    alter_table :monetary_unit_descriptions do
      add_column :abbreviation, String, size: 30
    end

    MonetaryUnitDescription.where(monetary_unit_code: 'EUC').update(abbreviation: 'EUR (EUC)')
  end

  down do
    alter_table :monetary_unit_descriptions do
      drop_column :abbreviation
    end
  end
end
