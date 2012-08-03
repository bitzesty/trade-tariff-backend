Sequel.migration do
  up do
    alter_table :chief_mfcm do
      add_column :tar_msr_no, String
    end

  end
  
  down do
    alter_table :chief_mfcm do
      drop_column :tar_msr_no
    end
  end
end
