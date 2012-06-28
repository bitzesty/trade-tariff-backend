class RegulationGroup < ActiveRecord::Base
  has_many :base_regulations
  has_one   :regulation_group_description
end
