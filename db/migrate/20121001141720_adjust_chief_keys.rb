Sequel.migration do
  up do
    alter_table :chief_mfcm do
      set_column_type :tar_msr_no, String, size: 12
      set_column_type :cmdty_code, String, size: 12
    end

    alter_table :chief_tamf do
      set_column_type :tar_msr_no, String, size: 12
      drop_index [:msrgp_code, :msr_type, :tty_code]
      add_index [:fe_tsmp, :msrgp_code, :msr_type, :tty_code, :tar_msr_no, :amend_indicator], name: 'index_chief_tamf'
    end

    alter_table :chief_tame do
      set_column_type :tar_msr_no, String, size: 12
      drop_index [:msrgp_code, :msr_type, :tty_code]
      add_index [:msrgp_code, :msr_type, :tty_code, :tar_msr_no, :fe_tsmp], name: 'index_chief_tame'
    end
  end

  down do
    alter_table :chief_mfcm do
      set_column_type :tar_msr_no, String, size: 255
      set_column_type :cmdty_code, String, size: 255
    end

    alter_table :chief_tamf do
      set_column_type :tar_msr_no, String, size: 255
      drop_index [:fe_tsmp, :msrgp_code, :msr_type, :tty_code, :tar_msr_no, :amend_indicator], name: 'index_chief_tamf'
    end

    alter_table :chief_tame do
      drop_index [:msrgp_code, :msr_type, :tty_code, :tar_msr_no, :fe_tsmp], name: 'index_chief_tame'
      add_index [:msrgp_code, :msr_type, :tty_code]
    end
  end
end
