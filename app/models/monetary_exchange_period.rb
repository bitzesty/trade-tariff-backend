class MonetaryExchangePeriod < Sequel::Model
  set_primary_key  [:monetary_exchange_period_sid, :parent_monetary_unit_code]

  # has_many :monetary_exchange_rates, foreign_key: :monetary_exchange_period_sid
  # belongs_to :parent_monetary_unit, foreign_key: :parent_monetary_unit_code,
  #                                   class_name: 'MonetaryUnit'
end


