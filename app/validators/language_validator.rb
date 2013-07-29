######### Conformance validations 130
class LanguageValidator < TradeTariffBackend::Validator
  validation :LA1, 'language id must be unique', on: [:create, :update] do
    validates :uniqueness, of: [:language_id]
  end

  validation :LA3, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
