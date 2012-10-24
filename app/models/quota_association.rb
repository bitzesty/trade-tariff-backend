class QuotaAssociation < Sequel::Model
  set_primary_key  :main_quota_definition_sid, :sub_quota_definition_sid
end


