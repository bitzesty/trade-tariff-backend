class NationalMeasurementUnit
  attr_reader :measurement_unit_code, :description

  def initialize(attributes = {})
    @measurement_unit_code = attributes.fetch(:measurement_unit_code, nil)
    @description = attributes.fetch(:description, nil)
  end
end
