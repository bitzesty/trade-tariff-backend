######### Conformance validations 140
class MeasureTypeSeriesValidator < TradeTariffBackend::Validator
  validation :MTS1, 'The measure type series must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measure_type_series_id, :measure_type_combination]
  end

  validation :MTS2, 'The measure type series cannot be deleted if it is associated with a measure type.', on: [:destroy] do |record|
    record.measure_types.none?
  end

  validation :MTS3, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
