class Certificate < ActiveRecord::Base
  self.primary_key = :certificate_code

  belongs_to :certificate_type, foreign_key: :certificate_type_code
  has_many :measure_conditions, foreign_key: :certificate_type
end
