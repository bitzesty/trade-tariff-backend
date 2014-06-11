Sequel.migration do
  up do
    alter_table :rollbacks do
      drop_column :redownload
      add_column :keep, TrueClass
    end
  end

  down do
    alter_table :rollbacks do
      add_column :redownload, TrueClass
      drop_column :keep
    end
  end
end
