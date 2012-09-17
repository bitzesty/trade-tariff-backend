Sequel.migration do
  change do
    alter_table :chief_tame do
      set_column_type :adval_rate, BigDecimal, size: [8, 3]
      set_column_type :alch_sgth, BigDecimal, size: [8, 3]
      set_column_type :cap_max_pct, BigDecimal, size: [8, 3]
    end    
    alter_table :chief_tamf do
      set_column_type :adval1_rate, BigDecimal, size: [8, 3]
      set_column_type :adval2_rate, BigDecimal, size: [8, 3]
    end
  end
end
