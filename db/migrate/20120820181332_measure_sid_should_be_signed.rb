Sequel.migration do
  up do
    alter_table :measures do
      set_column_type :measure_sid, "integer"
    end
  end

  down do
    alter_table :measures do
      set_column_type :measure_sid, "integer", :auto_increment => false
    end
  end
end
