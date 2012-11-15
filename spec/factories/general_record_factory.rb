require 'chief_transformer'
require 'tariff_synchronizer'

FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :search_reference do
    title { Forgery(:basic).text }
    reference { Forgery(:basic).text }
  end
end
