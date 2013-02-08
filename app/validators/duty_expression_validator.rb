######### Conformance validations 230
class DutyExpressionValidator < TradeTariffBackend::Validator
  validation :DE1, 'The code of the duty expression must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:duty_expression_id]
  end

  validation :DE2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
