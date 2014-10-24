FactoryGirl.define do
  sequence(:certificate_sid) { |n| n}

  factory :certificate do
    transient do
      description { Forgery(:basic).text }
    end

    certificate_type_code { Forgery(:basic).text(exactly: 1) }
    certificate_code      { Forgery(:basic).text(exactly: 3) }
    validity_start_date   { Date.today.ago(2.years) }
    validity_end_date     { nil }
  end

  factory :certificate_description_period do
    certificate_description_period_sid { generate(:certificate_sid) }
    certificate_type_code              { Forgery(:basic).text(exactly: 1) }
    certificate_code                   { Forgery(:basic).text(exactly: 3) }
    validity_start_date                { Date.today.ago(2.years) }
    validity_end_date                  { nil }
  end

  factory :certificate_description do
    transient do
      valid_at Time.now.ago(2.years)
      valid_to nil
    end

    certificate_description_period_sid { generate(:certificate_sid) }
    certificate_type_code              { Forgery(:basic).text(exactly: 1) }
    certificate_code                   { Forgery(:basic).text(exactly: 3) }
    description                        { Forgery(:lorem_ipsum).sentence }

    trait :with_period do
      after(:create) { |cert_description, evaluator|
        FactoryGirl.create(:certificate_description_period, certificate_description_period_sid: cert_description.certificate_description_period_sid,
                                                            certificate_type_code: cert_description.certificate_type_code,
                                                            certificate_code: cert_description.certificate_code,
                                                            validity_start_date: evaluator.valid_at,
                                                            validity_end_date: evaluator.valid_to)
      }
    end
  end

  factory :certificate_type do
    transient do
      description { Forgery(:basic).text }
    end

    certificate_type_code              { Forgery(:basic).text(exactly: 1) }
    validity_start_date                { Date.today.ago(2.years) }
    validity_end_date                  { nil }

    trait :with_description do
      after(:create) { |certificate_type, evaluator|
        FactoryGirl.create(:certificate_type_description,
                           certificate_type_code: certificate_type.certificate_type_code,
                           description: evaluator.description)
      }
    end
  end

  factory :certificate_type_description do
    certificate_type_code { Forgery(:basic).text(exactly: 1) }
    description           { Forgery(:basic).text }
  end
end
