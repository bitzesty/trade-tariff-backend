class MonetaryExchangeRateSerializer < Serializer
  def serializable_hash(opts = {})
    {
      child_monetary_unit_code: child_monetary_unit_code,
      exchange_rate: exchange_rate,
      operation_date: operation_date,
      validity_start_date: monetary_exchange_period.validity_start_date
    }
  end
end
