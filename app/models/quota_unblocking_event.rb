class QuotaUnblockingEvent < Sequel::Model
  plugin :oplog, primary_key: [:oid, :quota_definition_sid]
  set_primary_key [:quota_definition_sid]

  def self.status
    'unblocked'
  end
end


