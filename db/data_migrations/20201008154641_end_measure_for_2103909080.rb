TradeTariffBackend::DataMigrator.migration do
  name 'Delete 425 measure for commodity 2103909080.'

  MEASURE_TYPE = 'DBE'
  COMMODITY = '2103909080'
  VALIDITY_END_DATE: '2020-02-29 00:00:00'

  up do
    applicable { true }

    apply do
      if measure = Measure::Operation.where(
          measure_type_id: MEASURE_TYPE, 
          goods_nomenclature_item_id: COMMODITY
        )
        measure.validity_end_date = VALIDITY_END_DATE
        measure.save!
      end
    end
  end

  down { }
end
