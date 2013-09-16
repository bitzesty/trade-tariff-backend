require 'chief_transformer'
require 'tariff_synchronizer'

FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :search_reference do
    association :heading

    title { Forgery(:basic).text }
  end
end
