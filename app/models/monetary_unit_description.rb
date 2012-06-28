class MonetaryUnitDescription < ActiveRecord::Base
  self.primary_key = [:monetary_unit_code, :language_id]

  belongs_to :monetary_unit, foreign_key: :monetary_unit_code
  belongs_to :language
end
