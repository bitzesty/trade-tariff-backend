FactoryGirl.define do
  sequence(:additional_code_sid) { |n| n}
  sequence(:additional_code_description_period_sid) { |n| n}

  factory :additional_code do
    additional_code_sid     { generate(:additional_code_sid) }
    additional_code_type_id { Forgery(:basic).text(exactly: 1) }
    additional_code         { Forgery(:basic).text(exactly: 3) }
    validity_start_date     { Date.today.ago(2.years) }
    validity_end_date       { nil }
  end

  factory :additional_code_description_period do
    additional_code_description_period_sid { generate(:additional_code_sid) }
    additional_code_sid                    { generate(:additional_code_sid) }
    additional_code_type_id                { Forgery(:basic).text(exactly: 1) }
    additional_code                        { Forgery(:basic).text(exactly: 3) }
    validity_start_date                    { Date.today.ago(2.years) }
    validity_end_date                      { nil }
  end

  factory :additional_code_description do
    ignore do
      valid_at Time.now.ago(2.years)
      valid_to nil
    end

    additional_code_description_period_sid { generate(:additional_code_sid) }
    additional_code_sid                    { generate(:additional_code_sid) }
    additional_code_type_id                { Forgery(:basic).text(exactly: 1) }
    additional_code                        { Forgery(:basic).text(exactly: 3) }
    description                            { Forgery(:lorem_ipsum).sentence }

    trait :with_period do
      after(:create) { |adco_description, evaluator|
        FactoryGirl.create(:additional_code_description_period, additional_code_description_period_sid: adco_description.additional_code_description_period_sid,
                                                                additional_code_sid: adco_description.additional_code_sid,
                                                                additional_code_type_id: adco_description.additional_code_type_id,
                                                                additional_code: adco_description.additional_code,
                                                                validity_start_date: evaluator.valid_at,
                                                                validity_end_date: evaluator.valid_to)
      }
    end
  end
end
