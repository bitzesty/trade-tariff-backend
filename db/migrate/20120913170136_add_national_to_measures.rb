Sequel.migration do
  up do
    alter_table :measures do
      add_column :national, TrueClass
      add_column :export, TrueClass
    end
  end

  down do
    alter_table :measures do
      drop_column :national
      drop_column :export
    end
  end
end
