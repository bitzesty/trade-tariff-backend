class QuotaUnblockingEvent < ActiveRecord::Base
  belongs_to :quota_definition, foreign_key: :quota_definition_sid
end
