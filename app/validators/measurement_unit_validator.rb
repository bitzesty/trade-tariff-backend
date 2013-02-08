######### Conformance validations 210
class MeasurementUnitValidator < TradeTariffBackend::Validator
  validation :MU1, 'The measurement unit code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measurement_unit_code]
  end

  validation :MU2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
