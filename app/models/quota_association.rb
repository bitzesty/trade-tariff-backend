class QuotaAssociation < Sequel::Model
  set_primary_key  :main_quota_definition_sid, :sub_quota_definition_sid

  # belongs_to :main_quota_definition, foreign_key: :main_quota_definition_sid,
  #                                    class_name: 'QuotaDefinition'
  # belongs_to :sub_quota_definition, foreign_key: :sub_quota_definition_sid,
  #                                   class_name: 'QuotaDefinition'
end

# == Schema Information
#
# Table name: quota_associations
#
#  record_code               :string(255)
#  subrecord_code            :string(255)
#  record_sequence_number    :string(255)
#  main_quota_definition_sid :integer(4)
#  sub_quota_definition_sid  :integer(4)
#  relation_type             :string(255)
#  coefficient               :decimal(16, 5)
#  created_at                :datetime
#  updated_at                :datetime
#

