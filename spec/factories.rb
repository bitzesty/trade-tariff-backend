FactoryGirl.define do
  factory :commodity do
    sequence(:goods_nomenclature_sid) {|n| n }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    producline_suffix   { [10,20,80].sample }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

    trait :expired do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { Date.today.ago(1.year)  }
    end
  end
end
