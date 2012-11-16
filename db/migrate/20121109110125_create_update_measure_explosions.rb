Sequel.migration do
  up do
    MeasureType.national.update(measure_explosion_level: 20)
  end

  def down
    MeasureType.national.update(measure_explosion_level: 2)
  end
end
