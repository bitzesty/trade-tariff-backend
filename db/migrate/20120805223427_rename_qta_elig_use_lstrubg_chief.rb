Sequel.migration do
  up do
    alter_table :chief_tame do
      rename_column :qta_elig_useLstrubg, :qta_elig_use
    end
  end
  
  down do
    alter_table :chief_tame do
      rename_column :qta_elig_use, :qta_elig_useLstrubg
    end
  end
end
