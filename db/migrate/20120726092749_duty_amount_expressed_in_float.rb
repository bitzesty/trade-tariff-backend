Sequel.migration do
  up do
    alter_table :measure_conditions do
      set_column_type :condition_duty_amount, Float
    end

    alter_table :measure_components do
      set_column_type :duty_amount, Float
    end

    alter_table :measure_condition_components do
      set_column_type :duty_amount, Float
    end
  end

  down do
    alter_table :measure_conditions do
      set_column_type :condition_duty_amount, Integer
    end

    alter_table :measure_components do
      set_column_type :duty_amount, Integer
    end

    alter_table :measure_condition_components do
      set_column_type :duty_amount, Integer
    end
  end
end
