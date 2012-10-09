Sequel.migration do
  up do
    alter_table :duty_expression_descriptions do
      add_column :abbreviation, String, size: 30
    end
  end

  down do
    alter_table :duty_expression_descriptions do
      drop_column :abbreviation
    end
  end
end
