Sequel.migration do
  change do
    alter_table :chief_mfcm do
      add_column :origin, String, size: 30
    end

    alter_table :chief_tame do
      add_column :origin, String, size: 30
    end

    alter_table :chief_tamf do
      add_column :origin, String, size: 30
    end
  end
end
