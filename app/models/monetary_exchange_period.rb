class MonetaryExchangePeriod < ActiveRecord::Base
  set_primary_keys :record_code, :subrecord_code

  has_many :monetary_exchange_rates
  belongs_to :parent_monetary_unit, foreign_key: :parent_monetary_unit_code,
                                    class_name: 'MonetaryUnit'
end
