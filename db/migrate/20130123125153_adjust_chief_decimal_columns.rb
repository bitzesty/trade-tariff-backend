Sequel.migration do
  up do
    alter_table :chief_comm do
      set_column_type :full_dty_adval1, BigDecimal, size: [6, 3]
      set_column_type :full_dty_adval2, BigDecimal, size: [6, 3]

      set_column_type :full_dty_spfc1, BigDecimal, size: [8, 4]
      set_column_type :full_dty_spfc2, BigDecimal, size: [8, 4]
    end
  end

  down do
    alter_table :chief_comm do
      set_column_type :full_dty_adval1, BigDecimal, size: [3, 3]
      set_column_type :full_dty_adval2, BigDecimal, size: [3, 3]

      set_column_type :full_dty_spfc1, BigDecimal, size: [7, 4]
      set_column_type :full_dty_spfc2, BigDecimal, size: [7, 4]
    end
  end
end
