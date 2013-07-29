######### Conformance validations 150
class RegulationGroupValidator < TradeTariffBackend::Validator
  validation :RG1, 'The Regulation group id must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:regulation_group_id]
  end

  validation :RG2, 'The Regulation group cannot be deleted if it is used in a base regulation.', on: [:destroy] do |record|
    record.base_regulations.none?
  end

  validation :RG3, 'The start date must be less than or equal to the end date if the end date is explicit.' do
    validates :validity_dates
  end
end
