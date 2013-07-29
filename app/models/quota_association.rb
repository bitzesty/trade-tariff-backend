class QuotaAssociation < Sequel::Model
  plugin :oplog, primary_key: [:main_quota_definition_sid,
                               :sub_quota_definition_sid]
  plugin :conformance_validator

  set_primary_key [:main_quota_definition_sid, :sub_quota_definition_sid]
end


