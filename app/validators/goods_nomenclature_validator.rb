class GoodsNomenclatureValidator < TradeTariffBackend::Validator
  validation :NIG4, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
