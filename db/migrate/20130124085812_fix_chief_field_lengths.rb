Sequel.migration do
  up do
    alter_table :chief_tamf do
      set_column_type :spfc1_rate, BigDecimal, size: [8, 4]
      set_column_type :spfc2_rate, BigDecimal, size: [8, 4]
      set_column_type :spfc3_rate, BigDecimal, size: [8, 4]
    end

    alter_table :chief_tame do
      add_column :ec_sctr, String, size: 10
    end
  end

  down do
    alter_table :chief_tamf do
      set_column_type :spfc1_rate, BigDecimal, size: [7, 4]
      set_column_type :spfc2_rate, BigDecimal, size: [7, 4]
      set_column_type :spfc3_rate, BigDecimal, size: [7, 4]
    end

    alter_table :chief_tame do
      drop_column :ec_sctr
    end
  end
end
