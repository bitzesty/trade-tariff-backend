class RegulationGroup < ActiveRecord::Base
  self.primary_key = :regulation_group_id

  has_many :base_regulations
end
