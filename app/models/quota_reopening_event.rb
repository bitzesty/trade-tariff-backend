class QuotaReopeningEvent < Sequel::Model
  set_primary_key  :quota_definition_sid

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  def self.status
    'reopened'
  end
end


