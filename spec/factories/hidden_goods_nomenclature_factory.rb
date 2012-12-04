FactoryGirl.define do
  factory :hidden_goods_nomenclature do
    goods_code_identifier { 10.times.map{ Random.rand(9) }.join }

    trait :chapter do
      goods_code_identifier { "#{2.times.map{ Random.rand(9) }.join}00000000" }
    end

    trait :heading do
      goods_code_identifier { "#{4.times.map{ Random.rand(8)+1 }.join}000000" }
    end
  end
end
