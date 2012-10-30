class MeasurementUnit < Sequel::Model
  plugin :time_machine

  set_primary_key  :measurement_unit_code

  one_to_one :measurement_unit_description, primary_key: :measurement_unit_code,
                                            key: :measurement_unit_code

  delegate :description, to: :measurement_unit_description

  ######### Conformance validations 210
  validates do
    # MU1
    uniqueness_of :measurement_unit_code
    # MU2
    validity_dates
    # TODO: MU3
    # TODO: MU6
  end

  def to_s
    description
  end
end


