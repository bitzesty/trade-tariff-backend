class QuotaAssociation < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]
  
  belongs_to :main_quota_definition, foreign_key: :main_quota_definition_sid,
                                     class_name: 'QuotaDefinition'
  belongs_to :sub_quota_definition, foreign_key: :sub_quota_definition_sid,
                                    class_name: 'QuotaDefinition'
end
