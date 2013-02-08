Sequel.migration do
  up do
    alter_table :certificate_types do
      drop_index [:certificate_type_code], name: :cert_types_pk
      add_index [:certificate_type_code, :validity_start_date], name: :cert_types_pk
    end

    alter_table :measure_types do
      drop_index [:measure_type_id], name: :meas_type_pk
      add_index [:measure_type_id, :validity_start_date], name: :meas_type_pk
    end

    alter_table :duty_expressions do
      drop_index [:duty_expression_id], name: :duty_exp_pk
      add_index [:duty_expression_id, :validity_start_date], name: :duty_exp_pk
    end

    alter_table :measurement_units do
      drop_index [:measurement_unit_code], name: :meas_unit_pk
      add_index [:measurement_unit_code, :validity_start_date], name: :meas_unit_pk
    end

    alter_table :monetary_units do
      drop_index [:monetary_unit_code], name: :mon_unit_pk
      add_index [:monetary_unit_code, :validity_start_date], name: :mon_unit_pk
    end

    alter_table :measurement_unit_qualifiers do
      drop_index [:measurement_unit_qualifier_code], name: :meas_unit_qual_pk
      add_index [:measurement_unit_qualifier_code, :validity_start_date], name: :meas_unit_qual_pk
    end

    alter_table :measure_condition_codes do
      drop_index [:condition_code], name: :meas_cond_cd_pk
      add_index [:condition_code, :validity_start_date], name: :meas_cond_cd_pk
    end

    alter_table :measure_actions do
      drop_index [:action_code], name: :meas_act_pk
      add_index [:action_code, :validity_start_date], name: :meas_act_pk
    end

    alter_table :certificates do
      drop_index [:certificate_code, :certificate_type_code], name: :cert_pk
      add_index [:certificate_code, :certificate_type_code, :validity_start_date], name: :cert_pk
    end
  end

  down do
    alter_table :certificate_types do
      drop_index [:certificate_type_code, :validity_start_date], name: :cert_types_pk
      add_index [:certificate_type_code], name: :cert_types_pk
    end

    alter_table :measure_types do
      drop_index [:measure_type_id, :validity_start_date], name: :meas_type_pk
      add_index [:measure_type_id], name: :meas_type_pk
    end

    alter_table :duty_expressions do
      drop_index [:duty_expression_id, :validity_start_date], name: :duty_exp_pk
      add_index [:duty_expression_id], name: :duty_exp_pk
    end

    alter_table :measurement_units do
      drop_index [:measurement_unit, :validity_start_date], name: :meas_unit_pk
      add_index [:measurement_unit], name: :meas_unit_pk
    end

    alter_table :monetary_units do
      drop_index [:monetary_unit, :validity_start_date], name: :mon_unit_pk
      add_index [:monetary_unit], name: :mon_unit_pk
    end

    alter_table :measurement_unit_qualifiers do
      drop_index [:measurement_unit_qualifier_code, :validity_start_date], name: :meas_unit_qual_pk
      add_index [:measurement_unit_qualifier_code], name: :meas_unit_qual_pk
    end

    alter_table :measure_condition_codes do
      drop_index [:condition_code, :validity_start_date], name: :meas_cond_cd_pk
      add_index [:condition_code], name: :meas_cond_cd_pk
    end

    alter_table :measure_actions do
      drop_index [:action_code, :validity_start_date], name: :meas_act_pk
      add_index [:action_code], name: :meas_act_pk
    end

    alter_table :certificates do
      drop_index [:certificate_code, :certificate_type_code, :validity_start_date], name: :cert_pk
      add_index [:certificate_code, :certificate_type_code], name: :cert_pk
    end
  end
end
