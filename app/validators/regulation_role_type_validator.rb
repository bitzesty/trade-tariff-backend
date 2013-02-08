######### Conformance validations 160
class RegulationRoleTypeValidator < TradeTariffBackend::Validator
  validation :RT5, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
