class MonetaryUnit < Sequel::Model
  plugin :time_machine

  set_primary_key  :monetary_unit_code

  one_to_one :monetary_unit_description, key: :monetary_unit_code,
                                         primary_key: :monetary_unit_code

  delegate :description, to: :monetary_unit_description

  def to_s
    monetary_unit_code
  end

  # has_many :measure_condition_components, foreign_key: :monetary_unit_code
  # has_many :monetary_exchange_periods, foreign_key: :parent_monetary_unit_code
  # has_many :monetary_exchange_rates, foreign_key: :child_monetary_unit_code
  # has_many :quota_definitions, foreign_key: :monetary_unit_code
  # has_many :measure_components, foreign_key: :monetary_unit_code
  # has_many :measure_conditions, foreign_key: :monetary_unit_code
  # has_many :measure_condition_components, foreign_key: :monetary_unit_code
  # has_one  :monetary_unit_description, foreign_key: :monetary_unit_code
end


