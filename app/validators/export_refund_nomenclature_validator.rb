class ExportRefundNomenclatureValidator < TradeTariffBackend::Validator
  validation :ERN5, 'The start date of the ERN must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
