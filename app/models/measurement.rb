class Measurement < ActiveRecord::Base
  self.primary_key = [:measurement_unit_code, :measurement_unit_qualifier_code]

  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  has_many :measure_components, foreign_key: [:measurement_unit_code, :measurement_unit_qualifier_code]
end
