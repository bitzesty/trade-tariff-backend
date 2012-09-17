Sequel.migration do
  change do
    alter_table :chief_mfcm do
      add_column :amend_indicator, String, :size=>1
    end
    alter_table :chief_tame do
      add_column :amend_indicator, String, :size=>1
    end    
    alter_table :chief_tamf do
      add_column :amend_indicator, String, :size=>1
    end
  end
end
