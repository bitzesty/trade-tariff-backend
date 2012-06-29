class MeasurementUnitQualifierDescription < ActiveRecord::Base
  self.primary_key = [:measurement_unit_qualifier_code, :language_id]

  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :language
end
