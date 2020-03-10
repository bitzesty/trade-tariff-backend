TradeTariffBackend::DataMigrator.migration do
  name "Create measure conditions for Beer (440 and 441) measure types"

  MEASURE_TYPES = %w(DDJ DDA)
  CONDITIONS = {
    1 => 5000.0,
    2 => 30000.0,
    3 => 60000.0,
    4 => 6000000.0
  }

  up do
    applicable {
      true
    }

    apply {
      operation_date = Date.today

      unrestrict_primary_keys

      Sequel::Model.db.transaction do
        create_measurement(operation_date)
        create_measurement_unit(operation_date)
        create_measurement_unit_description(operation_date)
        create_measure_conditions(operation_date)
      end
    }
  end

  down do
    applicable {
      true
    }
    apply {
      MeasureCondition::Operation.where(
        measure_sid: measure_sids,
        component_sequence_number: CONDITIONS.keys,
        condition_duty_amount: CONDITIONS.values,
        condition_monetary_unit_code: nil,
        condition_measurement_unit_code: "GP1",
        condition_measurement_unit_qualifier_code: nil,
        action_code: "01",
        certificate_type_code: nil,
        certificate_code: nil,
        condition_code: "E",
        operation: "C"
      ).delete
    }
  end

  def measure_sids
    Measure.actual.where(measure_type_id: MEASURE_TYPES).pluck(:measure_sid)
  end

  def unrestrict_primary_keys
    MeasureCondition.unrestrict_primary_key
    Measurement.unrestrict_primary_key
    MeasurementUnit.unrestrict_primary_key
    MeasurementUnitDescription.unrestrict_primary_key
  end

  def create_measurement(operation_date)
    if Measurement.where(measurement_unit_code: "GP1", measurement_unit_qualifier_code: "X").none?
      Measurement.new(
        measurement_unit_code: "GP1",
        measurement_unit_qualifier_code: "X",
        validity_start_date: Date.new(1991,01,01),
        validity_end_date: nil,
        operation: "C",
        operation_date: operation_date
      ).save
    end
  end

  def create_measurement_unit(operation_date)
    if MeasurementUnit.where(measurement_unit_code: "GP1").none?
      MeasurementUnit.new(
        measurement_unit_code: "GP1",
        validity_start_date: Date.new(1991,01,01),
        validity_end_date: nil,
        operation: "C",
        operation_date: operation_date
      ).save
    end
  end

  def create_measurement_unit_description(operation_date)
    if MeasurementUnitDescription.where(measurement_unit_code: "GP1", description: "Gross Production").none?
      MeasurementUnitDescription.new(
        measurement_unit_code: "GP1",
        language_id: "EN",
        description: "Gross Production",
        operation: "C",
        operation_date: operation_date
      ).save
    end
  end

  def create_measure_conditions(operation_date)
    measure_sids.each do |measure_sid|
      CONDITIONS.each do |component_sequence_number,condition_duty_amount|

        attributes = {
          measure_sid: measure_sid,
          component_sequence_number: component_sequence_number,
          condition_duty_amount: condition_duty_amount,
          condition_monetary_unit_code: nil,
          condition_measurement_unit_code: "GP1",
          condition_measurement_unit_qualifier_code: nil,
          action_code: "01",
          certificate_type_code: nil,
          certificate_code: nil,
          condition_code: "E",
          operation: "C"
        }

        if MeasureCondition.where(attributes).none?
          MeasureCondition.new(
            attributes.merge(operation_date: operation_date)
          ).save
        end
      end
    end
  end
end
