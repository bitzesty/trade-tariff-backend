require 'chief_transformer'
require 'tariff_synchronizer'

FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :search_reference do
    title { Forgery(:basic).text }
    reference { Forgery(:basic).text }
  end

  factory :chief_update, class: TariffSynchronizer::ChiefUpdate do
    ignore do
      example_date { Forgery(:date).date }
    end

    filename { TariffSynchronizer::ChiefUpdate.file_name_for(example_date)  }
    issue_date { example_date }
    update_type { 'TariffSynchronizer::ChiefUpdate' }
    state { 'P' }

    trait :applied do
      state { 'A' }
    end
  end

  factory :taric_update, class: TariffSynchronizer::TaricUpdate do
    ignore do
      example_date { Forgery(:date).date }
    end

    filename { TariffSynchronizer::TaricUpdate.file_name_for(example_date)  }
    issue_date { example_date }
    update_type { 'TariffSynchronizer::TaricUpdate' }
    state { 'P' }

    trait :applied do
      state { 'A' }
    end
  end
end
