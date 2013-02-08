######### Conformance validations 240
class AdditionalCodeTypeMeasureTypeValidator < TradeTariffBackend::Validator
  validation [:AMT1, :AMT2], 'The measure type must exist The additional code type must exist.', on: [:create, :update] do
    validates :presence, of: [:measure_type, :additional_code_type]
  end

  validation :AMT3, 'The combination of additional code type and measure type must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:measure_type_id, :additional_code_type_id]
  end

  validation :AMT5, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
