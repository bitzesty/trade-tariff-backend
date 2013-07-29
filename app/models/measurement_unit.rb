class MeasurementUnit < Sequel::Model
  plugin :oplog, primary_key: :measurement_unit_code
  plugin :time_machine
  plugin :conformance_validator

  set_primary_key [:measurement_unit_code]

  one_to_one :measurement_unit_description, primary_key: :measurement_unit_code,
                                            key: :measurement_unit_code

  delegate :description, to: :measurement_unit_description

  def to_s
    description
  end
end
