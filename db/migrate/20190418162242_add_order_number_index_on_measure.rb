Sequel.migration do
  up do
    alter_table :measures_oplog do
      add_index [:ordernumber, :validity_start_date]
    end
  end

  down do
    alter_table :measures_oplog do
      drop_index [:ordernumber, :validity_start_date]
    end
  end
end
