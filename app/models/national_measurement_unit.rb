class NationalMeasurementUnit
  attr_reader :measurement_unit_code, :description, :level

  def initialize(attributes = {})
    @measurement_unit_code = attributes.fetch(:measurement_unit_code, nil)
    @description = attributes.fetch(:description, nil)
    @level = attributes.fetch(:level)
  end

  def description
    self.class.description_map.fetch(measurement_unit_code, nil)
  end

  def present?
    description.present?
  end

  def to_s
    description
  end

  def self.description_map
    {
     '048' => 'Hectokilogram Net Dry Matter (100kg/net mas)',
     '066' => 'Litre of Alcohol',
     '070' => 'Standard Litre of Hydrocarbon Oil',
     '100' => '% Lactic Matter / 100 Kg Product',
     '101' => '% Lactic Dry Matter / 100 Kg Product',
     '102' => '% Sucrose Content / 100 Kg Net',
     '104' => '% Added Sugar / 100 Kg',
     '106' => '% Actual Alcoholic Strength / Hectolitre'
    }
  end
end
