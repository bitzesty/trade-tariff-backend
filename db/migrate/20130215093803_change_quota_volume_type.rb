Sequel.migration do
  up do
    alter_table :quota_definitions_oplog do
      set_column_type :volume, BigDecimal, size: [12,2]
      set_column_type :initial_volume, BigDecimal, size: [12,2]
    end

    alter_table :quota_balance_events_oplog do
      set_column_type :old_balance, BigDecimal, size: [12,3]
      set_column_type :new_balance, BigDecimal, size: [12,3]
      set_column_type :imported_amount, BigDecimal, size: [12,3]
    end
  end

  down do
    alter_table :quota_definitions_oplog do
      set_column_type :volume, Integer
      set_column_type :initial_volume, Integer
    end

    alter_table :quota_balance_events_oplog do
      set_column_type :old_balance, Integer
      set_column_type :new_balance, Integer
      set_column_type :imported_amount, Integer
    end
  end
end
