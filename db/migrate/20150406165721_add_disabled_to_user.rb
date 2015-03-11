Sequel.migration do
  up do
    alter_table :users do
      add_column :disabled, FalseClass, default: false
    end
  end

  down do
    alter_table :users do
      drop_column :disabled
    end
  end
end
