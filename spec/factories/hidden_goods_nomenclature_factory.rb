FactoryGirl.define do
  factory :hidden_goods_nomenclature do
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }

    trait :chapter do
      goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }
    end

    trait :heading do
      goods_nomenclature_item_id { "#{4.times.map{ Random.rand(8)+1 }.join}000000" }
    end
  end
end
