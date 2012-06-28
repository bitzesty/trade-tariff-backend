class RegulationGroupDescription < ActiveRecord::Base
  belongs_to :regulation_group
  belongs_to :language
end
