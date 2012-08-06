Sequel.migration do
  change do
    alter_table :chief_mfcm do
      add_column :transformed, :boolean, default: false
    end
    alter_table :chief_tame do
      add_column :transformed, :boolean, default: false
    end    
    alter_table :chief_tamf do
      add_column :transformed, :boolean, default: false
    end
  end
end
