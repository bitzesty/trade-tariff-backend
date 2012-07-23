class QuotaAssociation < Sequel::Model
  set_primary_key  :main_quota_definition_sid, :sub_quota_definition_sid

  # belongs_to :main_quota_definition, foreign_key: :main_quota_definition_sid,
  #                                    class_name: 'QuotaDefinition'
  # belongs_to :sub_quota_definition, foreign_key: :sub_quota_definition_sid,
  #                                   class_name: 'QuotaDefinition'
end


