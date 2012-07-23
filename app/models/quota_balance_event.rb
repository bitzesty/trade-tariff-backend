class QuotaBalanceEvent < Sequel::Model
  set_primary_key  [:quota_definition_sid, :occurance_timestamp]

  # belongs_to :quota_definition, foreign_key: :quota_definition_sid
end


