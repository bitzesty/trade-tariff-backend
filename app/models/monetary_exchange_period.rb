class MonetaryExchangePeriod < Sequel::Model
  set_primary_key  [:monetary_exchange_period_sid, :parent_monetary_unit_code]

  # has_many :monetary_exchange_rates, foreign_key: :monetary_exchange_period_sid
  # belongs_to :parent_monetary_unit, foreign_key: :parent_monetary_unit_code,
  #                                   class_name: 'MonetaryUnit'
end

# == Schema Information
#
# Table name: monetary_exchange_periods
#
#  id                           :integer(4)      not null
#  record_code                  :string(255)
#  subrecord_code               :string(255)
#  record_sequence_number       :string(255)
#  monetary_exchange_period_sid :string(255)
#  parent_monetary_unit_code    :string(255)
#  validity_start_date          :date
#  validity_end_date            :date
#  created_at                   :datetime
#  updated_at                   :datetime
#

