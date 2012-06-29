class QuotaAssociation < ActiveRecord::Base
  belongs_to :main_quota_definition, foreign_key: :main_quota_definition_sid,
                                     class_name: 'QuotaDefinition'
  belongs_to :sub_quota_definition, foreign_key: :sub_quota_definition_sid,
                                    class_name: 'QuotaDefinition'
end
