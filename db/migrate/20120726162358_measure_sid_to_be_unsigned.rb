Sequel.migration do
  up do
    alter_table :measures do
      set_column_type :measure_sid, "int(11)", :unsigned => true, :auto_increment => false
    end
  end
  
  down do
    alter_table :measures do
      set_column_type :measure_sid, "int(11)"
    end
  end
end
