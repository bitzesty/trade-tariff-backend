class MonetaryExchangePeriod < ActiveRecord::Base
  self.primary_key = :monetary_exchange_period_sid

  has_many :monetary_exchange_rates
  belongs_to  :parent_monetary_unit, foreign_key: :parent_monetary_unit_code
end
