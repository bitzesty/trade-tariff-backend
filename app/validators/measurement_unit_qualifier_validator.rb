######### Conformance validations 215
class MeasurementUnitQualifierValidator < TradeTariffBackend::Validator
  validation :MUQ1, 'The measurement unit qualifier code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measurement_unit_qualifier_code]
  end

  validation :MUQ2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
