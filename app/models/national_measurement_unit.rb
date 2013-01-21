class NationalMeasurementUnit < Sequel::Model
  set_primary_key  :measurement_unit_code

  validates do
    uniqueness_of :measurement_unit_code
  end

  def to_s
    description
  end
end
