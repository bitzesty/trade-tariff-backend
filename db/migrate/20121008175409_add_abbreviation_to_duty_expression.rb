Sequel.migration do
  change do
    alter_table :duty_expressions do
      add_column :abbreviation, String, size: 30
    end
  end
end
