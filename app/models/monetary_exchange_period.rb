class MonetaryExchangePeriod < ActiveRecord::Base
  self.primary_key = [:record_code, :subrecord_code, :record_sequence_number]

  has_many :monetary_exchange_rates
  belongs_to :parent_monetary_unit, foreign_key: :parent_monetary_unit_code,
                                    class_name: 'MonetaryUnit'
end
