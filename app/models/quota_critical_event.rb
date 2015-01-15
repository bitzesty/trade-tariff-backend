class QuotaCriticalEvent < Sequel::Model
  plugin :oplog, primary_key: [:quota_definition_sid, :occurrence_timestamp]
  plugin :conformance_validator

  set_primary_key [:quota_definition_sid, :occurrence_timestamp]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  def self.status
    'critical'
  end
end


