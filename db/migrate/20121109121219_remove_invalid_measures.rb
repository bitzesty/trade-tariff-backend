Sequel.migration do

  # Traverse national measures and remove the ones that are not valid
  # Used when Mesure conformance validations are extended to remove the ones
  # that do not comply.
  up do
    Measure.national.each_page(1000) { |measure_batch|
      measure_batch.each { |measure|
        # Adjust measure validity date span
        if measure.goods_nomenclature.validity_end_date.present? &&
            measure.validity_end_date.present? &&
            measure.validity_end_date > measure.goods_nomenclature.validity_end_date
          measure.validity_end_date = measure.goods_nomenclature.validity_end_date
          measure.save
        end

        # Destroy measure if fails other validations
        measure.destroy unless measure.valid?
      }
    }
  end

  down do
  end
end
