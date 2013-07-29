Sequel.migration do
  up do
    Measure.national.where(measure_type_id: 'SPL').destroy
  end

  down do
  end
end
