collection @rates

attributes :child_monetary_unit_code, :exchange_rate, :operation_date, :validity_start_date
node(:validity_start_date) { |rate| rate.monetary_exchange_period.validity_start_date }
