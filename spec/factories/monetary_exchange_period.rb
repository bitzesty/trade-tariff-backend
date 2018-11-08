FactoryGirl.define do
  sequence(:monetary_exchange_sid) { |n| n}

  factory :monetary_exchange_period do
    monetary_exchange_period_sid { generate(:monetary_exchange_sid) }
    parent_monetary_unit_code "EUR"
    validity_start_date { Date.today.at_beginning_of_month }
    operation_date { validity_start_date - 4.day }

    trait :old do
      validity_start_date { Date.today.at_beginning_of_month - 6.years }
    end

    # after(:create) { |monetary_exchange_period, evaluator|
    #   FactoryGirl.create :monetary_exchange_rate, operation_date: monetary_exchange_period.operation_date, monetary_exchange_period: monetary_exchange_period
    # }
  end
end
