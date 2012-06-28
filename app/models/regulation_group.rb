class RegulationGroup < ActiveRecord::Base
  self.primary_key = :regulation_group_id

  has_many :base_regulations
  has_one   :regulation_group_description
end
