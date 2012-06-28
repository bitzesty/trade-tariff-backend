class CompleteAbrogationRegulation < ActiveRecord::Base
  self.primary_key = [:complete_abrogation_regulation_role, :complete_abrogation_regulation_id]

  has_many :modification_regulations
end
