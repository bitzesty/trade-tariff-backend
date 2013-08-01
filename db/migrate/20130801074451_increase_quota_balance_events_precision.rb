Sequel.migration do
  up do
    alter_table :quota_balance_events_oplog do
      set_column_type :old_balance, BigDecimal, size: [15,3]
      set_column_type :new_balance, BigDecimal, size: [15,3]
      set_column_type :imported_amount, BigDecimal, size: [15,3]
    end
  end

  down do
    alter_table :quota_balance_events_oplog do
      set_column_type :old_balance, BigDecimal, size: [10,3]
      set_column_type :new_balance, BigDecimal, size: [10,3]
      set_column_type :imported_amount, BigDecimal, size: [10,3]
    end
  end
end
