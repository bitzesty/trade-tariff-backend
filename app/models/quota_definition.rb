class QuotaDefinition < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  belongs_to :quota_order_number
  belongs_to :measurement_unit, foreign_key: :measurement_unit_code
  belongs_to :measurement_unit_qualifier, foreign_key: :measurement_unit_qualifier_code
  belongs_to :monetary_unit, foreign_key: :monetary_unit_code

  has_many :main_quota_associations, foreign_key: :main_quota_definition_sid,
                                     class_name: 'QuotaAssociation'
  has_many :sub_quota_associations, foreign_key: :sub_quota_definition_sid,
                                     class_name: 'QuotaAssociation'
  has_many :quota_balance_events, foreign_key: :quota_definition_sid
  has_many :quota_blocking_periods, foreign_key: :quota_definition_sid
  has_many :quota_critical_events, foreign_key: :quota_definition_sid
  has_many :quota_exhaustion_events, foreign_key: :quota_definition_sid
  has_many :quota_reopening_events, foreign_key: :quota_definition_sid
  has_many :quota_suspension_periods, foreign_key: :quota_definition_sid
  has_many :quota_unblocking_events, foreign_key: :quota_definition_sid
  has_many :quota_unsuspension_events, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_definitions
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  quota_definition_sid            :integer(4)
#  quota_order_number_id           :string(255)
#  validity_start_date             :date
#  validity_end_date               :date
#  quota_order_number_sid          :integer(4)
#  volume                          :integer(4)
#  initial_volume                  :integer(4)
#  measurement_unit_code           :string(255)
#  maximum_precision               :integer(4)
#  critical_state                  :string(255)
#  critical_threshold              :integer(4)
#  monetary_unit_code              :string(255)
#  measurement_unit_qualifier_code :string(255)
#  description                     :text
#  created_at                      :datetime
#  updated_at                      :datetime
#

