class QuotaExhaustionEvent < Sequel::Model
  set_primary_key  :quota_definition_sid

  # belongs_to :quota_definition, foreign_key: :quota_definition_sid
end


