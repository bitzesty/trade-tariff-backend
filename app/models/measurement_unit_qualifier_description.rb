require 'formatter'

class MeasurementUnitQualifierDescription < Sequel::Model
  include Formatter

  plugin :oplog, primary_key: :measurement_unit_qualifier_code
  plugin :conformance_validator

  set_primary_key [:measurement_unit_qualifier_code]

  format :formatted_measurement_unit_qualifier, with: DescriptionFormatter,
                                                using: :description
end
