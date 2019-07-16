TradeTariffBackend::DataMigrator.migration do
  name 'Create EXF national measure type with description'

  up do
    applicable do
      MeasureType.where(measure_type_id: 'EXF').blank?
    end

    apply do
      MeasureType.unrestrict_primary_key
      MeasureType.create(measure_type_id: 'EXF',
                         validity_start_date: Date.new(2019, 1, 9),
                         validity_end_date: nil,
                         trade_movement_code: '0',
                         priority_code: '5',
                         measure_component_applicable_code: '0',
                         measure_type_acronym: 'EXF',
                         origin_dest_code: '0',
                         order_number_capture_code: '2',
                         measure_explosion_level: '20',
                         measure_type_series_id: 'Q',
                         national: true,
                         operation: 'C')

      MeasureTypeDescription.unrestrict_primary_key
      MeasureTypeDescription.create(measure_type_id: 'EXF',
                                    language_id: 'EN',
                                    description: 'EXCISE - FULL, 487, CIDER AND PERRY EXCEEDING 6.9% - NOT EXCEEDING 7.5% ABV',
                                    national: true,
                                    operation: 'C')
    end
  end

  down do
    applicable {
      MeasureType.where(measure_type_id: 'EXF').present?
    }
    apply {
      MeasureTypeDescription.where(measure_type_id: 'EXF').map(&:destroy)
      MeasureType.where(measure_type_id: 'EXF').map(&:destroy)
    }
  end
end
