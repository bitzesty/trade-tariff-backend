class MeasurementUnitQualifier < Sequel::Model
  plugin :time_machine

  set_primary_key  :measurement_unit_qualifier_code

  one_to_one :measurement_unit_qualifier_description, key: :measurement_unit_qualifier_code,
                                                      primary_key: :measurement_unit_qualifier_code

  delegate :description, to: :measurement_unit_qualifier_description

  ######### Conformance validations 215
  def validate
    super
    # MUQ1
    validates_unique(:measurement_unit_qualifier_code)
    # MUQ2
    validates_start_date
    # TODO: MUQ3
    # TODO: MUQ4
    # TODO: MUQ5
  end


  # has_many :measure_components, foreign_key: :measurement_unit_qualifier_code
  # has_many :quota_definitions, foreign_key: :measurement_unit_qualifier_code
  # has_many :measure_condition_components, foreign_key: :measurement_unit_qualifier_code
  # has_many :measure_conditions, foreign_key: :condition_measurement_unit_qualifier_code
  # has_many :measurements, foreign_key: :measurement_unit_qualifier_code
  # has_one  :measurement_unit_qualifier_description, foreign_key: :measurement_unit_qualifier_code
end


