class NationalMeasurementUnit
  attr_reader :measurement_unit_code, :description, :level

  def initialize(attributes = {})
    @measurement_unit_code = attributes.fetch(:measurement_unit_code, nil)
    @description = attributes.fetch(:description, nil)
    @level = attributes.fetch(:level)
  end
end
