######### Conformance validations 290
class ModificationRegulationValidator < TradeTariffBackend::Validator
  validation :ROIMM1, 'The (regulation id + role id) must be unique.', on: %i[create update] do
    validates :uniqueness, of: %i[modification_regulation_id modification_regulation_role]
  end

  validation :ROIMM5, 'The start date must be less than or equal to the end date if the end date is explicit.' do
    validates :validity_dates
  end
end
