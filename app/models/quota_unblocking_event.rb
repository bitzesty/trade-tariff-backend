class QuotaUnblockingEvent < Sequel::Model
  plugin :oplog, primary_key: [:oid, :quota_definition_sid]
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid]

  def self.status
    'unblocked'
  end
end


