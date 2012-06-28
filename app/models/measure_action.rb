class MeasureAction < ActiveRecord::Base
  self.primary_key = :action_code

  has_one :description, foreign_key: :action_code
end
