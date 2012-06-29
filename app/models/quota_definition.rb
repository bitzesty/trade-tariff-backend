class QuotaDefinition < ActiveRecord::Base
  self.primary_key = :quota_definition_sid

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
