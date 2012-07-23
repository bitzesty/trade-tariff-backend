class MonetaryUnitDescription < Sequel::Model
  set_primary_key  :monetary_unit_code

  # belongs_to :monetary_unit, foreign_key: :monetary_unit_code
  # belongs_to :language
end


