Sequel.migration do
  up do
    alter_table :certificate_types do
      drop_index [:certificate_type_code], name: :primary_key
      add_index [:certificate_type_code, :validity_start_date], name: :primary_key
    end

    alter_table :measure_types do
      drop_index [:measure_type_id], name: :primary_key
      add_index [:measure_type_id, :validity_start_date], name: :primary_key
    end

    alter_table :duty_expressions do
      drop_index [:duty_expression_id], name: :primary_key
      add_index [:duty_expression_id, :validity_start_date], name: :primary_key
    end

    alter_table :measurement_units do
      drop_index [:measurement_unit_code], name: :primary_key
      add_index [:measurement_unit_code, :validity_start_date], name: :primary_key
    end

    alter_table :monetary_units do
      drop_index [:monetary_unit_code], name: :primary_key
      add_index [:monetary_unit_code, :validity_start_date], name: :primary_key
    end

    alter_table :measurement_unit_qualifiers do
      drop_index [:measurement_unit_qualifier_code], name: :primary_key
      add_index [:measurement_unit_qualifier_code, :validity_start_date], name: :primary_key
    end

    alter_table :measure_condition_codes do
      drop_index [:condition_code], name: :primary_key
      add_index [:condition_code, :validity_start_date], name: :primary_key
    end

    alter_table :measure_actions do
      drop_index [:action_code], name: :primary_key
      add_index [:action_code, :validity_start_date], name: :primary_key
    end

    alter_table :certificates do
      drop_index [:certificate_code, :certificate_type_code], name: :primary_key
      add_index [:certificate_code, :certificate_type_code, :validity_start_date], name: :primary_key
    end
  end

  down do
    alter_table :certificate_types do
      drop_index [:certificate_type_code, :validity_start_date], name: :primary_key
      add_index [:certificate_type_code], name: :primary_key
    end

    alter_table :measure_types do
      drop_index [:measure_type_id, :validity_start_date], name: :primary_key
      add_index [:measure_type_id], name: :primary_key
    end

    alter_table :duty_expressions do
      drop_index [:duty_expression_id, :validity_start_date], name: :primary_key
      add_index [:duty_expression_id], name: :primary_key
    end

    alter_table :measurement_units do
      drop_index [:measurement_unit, :validity_start_date], name: :primary_key
      add_index [:measurement_unit], name: :primary_key
    end

    alter_table :monetary_units do
      drop_index [:monetary_unit, :validity_start_date], name: :primary_key
      add_index [:monetary_unit], name: :primary_key
    end

    alter_table :measurement_unit_qualifiers do
      drop_index [:measurement_unit_qualifier_code, :validity_start_date], name: :primary_key
      add_index [:measurement_unit_qualifier_code], name: :primary_key
    end

    alter_table :measure_condition_codes do
      drop_index [:condition_code, :validity_start_date], name: :primary_key
      add_index [:condition_code], name: :primary_key
    end

    alter_table :measure_actions do
      drop_index [:action_code, :validity_start_date], name: :primary_key
      add_index [:action_code], name: :primary_key
    end

    alter_table :certificates do
      drop_index [:certificate_code, :certificate_type_code, :validity_start_date], name: :primary_key
      add_index [:certificate_code, :certificate_type_code], name: :primary_key
    end
  end
end
