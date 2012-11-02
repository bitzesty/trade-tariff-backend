class MeasurementUnitQualifier < Sequel::Model
  plugin :time_machine

  set_primary_key  :measurement_unit_qualifier_code

  one_to_one :measurement_unit_qualifier_description, key: :measurement_unit_qualifier_code,
                                                      primary_key: :measurement_unit_qualifier_code

  delegate :description, to: :measurement_unit_qualifier_description

  ######### Conformance validations 215
  validates do
    # MUQ1
    uniqueness_of :measurement_unit_qualifier_code
    # MUQ2
    validity_dates
    # TODO: MUQ3
    # TODO: MUQ4
    # TODO: MUQ5
  end
end


