Sequel.migration do
  up do
    Measure.national.where(measure_type: 'SPL').destroy
  end

  down do
  end
end
