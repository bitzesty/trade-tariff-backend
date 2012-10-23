class MeasureComponent < Sequel::Model
  plugin :time_machine
  plugin :timestamps

  set_primary_key :measure_sid, :duty_expression_id

  many_to_one :duty_expression, key: {}, primary_key: {}, eager_loader_key: :duty_expression_id, dataset: -> {
    actual(DutyExpression)
                  .where(duty_expression_id: duty_expression_id)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|mc| mc.associations[:duty_expression] = nil}

    id_map = eo[:id_map]

    DutyExpression.actual
                  .eager(:duty_expression_description)
                  .where(duty_expression_id: id_map.keys).all do |duty_expression|
      if measure_components = id_map[duty_expression.duty_expression_id]
        measure_components.each do |component|
          component.associations[:duty_expression] = duty_expression
        end
      end
    end
  end)


  many_to_one :measurement_unit, key: {}, primary_key: {}, eager_loader_key: :measurement_unit_code, dataset: -> {
    actual(MeasurementUnit)
                  .where(measurement_unit_code: measurement_unit_code)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|mc| mc.associations[:measurement_unit] = nil}

    id_map = eo[:id_map]

    MeasurementUnit.actual
                   .eager(:measurement_unit_description)
                   .where(measurement_unit_code: id_map.keys).all do |measurement_unit|
      if measure_components = id_map[measurement_unit.measurement_unit_code]
        measure_components.each do |component|
          component.associations[:measurement_unit] = measurement_unit
        end
      end
    end
  end)

  many_to_one :monetary_unit, key: {}, primary_key: {}, eager_loader_key: :monetary_unit_code, dataset: -> {
    actual(MonetaryUnit)
                  .where(monetary_unit_code: monetary_unit_code)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|mc| mc.associations[:monetary_unit] = nil}

    id_map = eo[:id_map]

    MonetaryUnit.actual
                .eager(:monetary_unit_description)
                .where(monetary_unit_code: id_map.keys).all do |monetary_unit|
      if measure_components = id_map[monetary_unit.monetary_unit_code]
        measure_components.each do |component|
          component.associations[:monetary_unit] = monetary_unit
        end
      end
    end
  end)

  many_to_one :measurement_unit_qualifier, key: {}, primary_key: {}, eager_loader_key: :measurement_unit_qualifier_code, dataset: -> {
    actual(MeasurementUnitQualifier)
                  .where(measurement_unit_qualifier_code: measurement_unit_qualifier_code)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|mc| mc.associations[:measurement_unit_qualifier] = nil}

    id_map = eo[:id_map]

    MeasurementUnitQualifier.actual
                            .eager(:measurement_unit_qualifier_description)
                            .where(measurement_unit_qualifier_code: id_map.keys)
                            .all do |measurement_unit_qualifier|
      if measure_components = id_map[measurement_unit_qualifier.measurement_unit_qualifier_code]
        measure_components.each do |component|
          component.associations[:measurement_unit_qualifier] = measurement_unit_qualifier
        end
      end
    end
  end)

  one_to_one :measure, key: :measure_sid,
                       primary_key: :measure_sid

  delegate :description, :abbreviation, to: :duty_expression, prefix: true
  delegate :abbreviation, to: :monetary_unit, prefix: true, allow_nil: true
end


