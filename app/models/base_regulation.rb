class BaseRegulation < ActiveRecord::Base
  self.primary_key = :base_regulation_id

  belongs_to :regulation_group
end
