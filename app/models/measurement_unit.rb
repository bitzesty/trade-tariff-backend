class MeasurementUnit < Sequel::Model
  plugin :time_machine

  set_primary_key  :measurement_unit_code

  one_to_one :measurement_unit_description, key: :measurement_unit_code, dataset: -> {
    MeasurementUnitDescription.where(measurement_unit_code: measurement_unit_code)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measurement_unit| measurement_unit.associations[:measurement_unit_description] = nil}

    id_map = eo[:id_map]

    MeasurementUnitDescription.where(measurement_unit_code: id_map.keys).all do |measurement_unit_description|
      if measurement_units = id_map[measurement_unit_description.measurement_unit_code]
        measurement_units.each do |measurement_unit|
          measurement_unit.associations[:measurement_unit_description] = measurement_unit_description
        end
      end
    end
  end)


  delegate :description, to: :measurement_unit_description

  ######### Conformance validations 210
  def validate
    super
    # MU1
    validates_unique(:measurement_unit_code)
    # MU2
    validates_start_date
    # TODO: MU3
    # TODO: MU6
  end

  def to_s
    description
  end
end


