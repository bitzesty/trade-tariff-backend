class Certificate < ActiveRecord::Base
  self.primary_key = :certificate_code

  belongs_to :certificate_type, foreign_key: :certificate_type_code
end
