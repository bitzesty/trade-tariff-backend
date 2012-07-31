class QuotaUnblockingEvent < Sequel::Model
  set_primary_key  :quota_definition_sid

  def self.status
    'unblocked'
  end
end


