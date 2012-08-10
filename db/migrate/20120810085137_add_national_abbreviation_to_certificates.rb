Sequel.migration do
  up do
    alter_table :certificates do
      add_column :national_abbrev, String
    end
  end

  down do
    alter_table :certificates do
      drop_column :national_abbrev
    end
  end
end
