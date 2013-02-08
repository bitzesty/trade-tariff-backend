######### Conformance validations 235
class MeasureTypeValidator < TradeTariffBackend::Validator
  validation :MT1, 'The  measure type code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measure_type_id]
  end

  validation :MT2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :MT4, 'The referenced measure type series must exist.', on: [:create, :update] do
    validates :presence, of: :measure_type_series
  end
end
