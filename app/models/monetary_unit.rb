class MonetaryUnit < ActiveRecord::Base
  self.primary_key = :monetary_unit_code

  has_many :measure_condition_components, foreign_key: :monetary_unit_code
  has_many :monetary_exchange_periods, foreign_key: :parent_monetary_unit_code
  has_many :monetary_exchange_rates, foreign_key: :child_monetary_unit_code
  has_one  :monetary_unit_description, foreign_key: :monetary_unit_code
  has_many :quota_definitions, foreign_key: :monetary_unit_code
end
