class MeasurementUnit < Sequel::Model
  plugin :oplog, primary_key: :measurement_unit_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code]

  one_to_one :measurement_unit_description, primary_key: :measurement_unit_code,
                                            key: :measurement_unit_code

  one_to_many :measurement_unit_abbreviations, primary_key: :measurement_unit_code,
                                               key: :measurement_unit_code

  delegate :description, to: :measurement_unit_description

  def to_s
    description
  end

  def abbreviation(options = {})
    measurement_unit_abbreviation(options)&.abbreviation || description
  end

  def measurement_unit_abbreviation(options = {})
    measurement_unit_qualifier = options[:measurement_unit_qualifier]
    measurement_unit_abbreviations.find do |abbreviation|
      abbreviation.measurement_unit_qualifier == measurement_unit_qualifier.try(:measurement_unit_qualifier_code)
    end
  end
end
