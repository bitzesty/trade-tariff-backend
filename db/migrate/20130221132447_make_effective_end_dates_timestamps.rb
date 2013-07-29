Sequel.migration do
  up do
    alter_table :base_regulations_oplog do
      set_column_type :effective_end_date, Time
    end

    alter_table :modification_regulations_oplog do
      set_column_type :effective_end_date, Time
    end
  end

  down do
    alter_table :base_regulations_oplog do
      set_column_type :effective_end_date, Date
    end

    alter_table :modification_regulations_oplog do
      set_column_type :effective_end_date, Date
    end
  end
end
