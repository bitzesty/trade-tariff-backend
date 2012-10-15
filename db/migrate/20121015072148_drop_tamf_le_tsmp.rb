Sequel.migration do
  up do
    alter_table :chief_tamf do
      drop_column :le_tsmp
      rename_column :transformed, :processed
    end

    alter_table :chief_mfcm do
      rename_column :transformed, :processed
    end

    alter_table :chief_tame do
      rename_column :transformed, :processed
    end
  end

  down do
    alter_table :chief_tamf do
      add_column :le_tsmp, DateTime
      rename_column :processed, :transformed
    end

    alter_table :chief_mfcm do
      rename_column :processed, :transformed
    end

    alter_table :chief_tame do
      rename_column :processed, :transformed
    end
  end
end
