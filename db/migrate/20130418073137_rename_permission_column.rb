Sequel.migration do
  up do
    alter_table :users do
      rename_column :permission, :permissions
    end
  end

  down do
    alter_table :users do
      rename_column :permissions, :permission
    end
  end
end
