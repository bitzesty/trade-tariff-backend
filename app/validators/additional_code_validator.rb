######### Conformance validations 245
class AdditionalCodeValidator < TradeTariffBackend::Validator
  validation 'ACN1: The combination of additional code type + additional code + start date must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:additional_code, :additional_code_type_id, :validity_start_date]
  end

  validation 'ACN3: The start date of the additional code must be less than or equal to the end date.', on: [:create, :update] do
    validates :validity_dates
  end
end
