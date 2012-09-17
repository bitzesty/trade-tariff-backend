Sequel.migration do
  up do
    alter_table :chief_tame do
      set_column_type :msrgp_code, String, size: 5
      set_column_type :msr_type, String, size: 5
      set_column_type :tty_code, String, size: 5
      add_index [:msrgp_code, :msr_type, :tty_code]
    end

    alter_table :chief_tamf do
      set_column_type :msrgp_code, String, size: 5
      set_column_type :msr_type, String, size: 5
      set_column_type :tty_code, String, size: 5
      add_index [:msrgp_code, :msr_type, :tty_code]
    end

    alter_table :chief_mfcm do
      set_column_type :msrgp_code, String, size: 5
      set_column_type :msr_type, String, size: 5
      set_column_type :tty_code, String, size: 5
      add_index :msrgp_code
    end
  end

  down do
    alter_table :chief_tame do
      drop_index [:msrgp_code, :msr_type, :tty_code]
      set_column_type :msrgp_code, String, size: 255
      set_column_type :msr_type, String, size: 255
      set_column_type :tty_code, String, size: 255
    end

    alter_table :chief_tamf do
      drop_index [:msrgp_code, :msr_type, :tty_code]
      set_column_type :msrgp_code, String, size: 255
      set_column_type :msr_type, String, size: 255
      set_column_type :tty_code, String, size: 255
    end

    alter_table :chief_mfcm do
      drop_index :msrgp_code
      set_column_type :msrgp_code, String, size: 255
      set_column_type :msr_type, String, size: 255
      set_column_type :tty_code, String, size: 255
    end
  end
end
