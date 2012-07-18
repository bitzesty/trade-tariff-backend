class MonetaryExchangeRate < Sequel::Model
  set_primary_key  :monetary_exchange_period_sid, :child_monetary_unit_code

  # belongs_to :monetary_exchange_period, foreign_key: :monetary_exchange_period_sid
  # belongs_to :child_monetary_unit, foreign_key: :child_monetary_unit_code,
  #                                  class_name: 'MonetaryUnit'
end

# == Schema Information
#
# Table name: monetary_exchange_rates
#
#  record_code                  :string(255)
#  subrecord_code               :string(255)
#  record_sequence_number       :string(255)
#  monetary_exchange_period_sid :string(255)
#  child_monetary_unit_code     :string(255)
#  exchange_rate                :decimal(16, 8)
#  created_at                   :datetime
#  updated_at                   :datetime
#

