module Api
  module V2
    class MonetaryExchangeRateSerializer
      include JSONAPI::Serializer

      set_type :monetary_exchange_rate

      set_id :oid

      attributes :child_monetary_unit_code, :exchange_rate, :operation_date

      attribute :validity_start_date do |rate|
        rate.monetary_exchange_period.validity_start_date
      end
    end
  end
end
