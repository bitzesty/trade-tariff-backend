FactoryGirl.define do
  factory :rollback do
    date { Date.current }
    reason { SecureRandom.hex }
    user_id { create(:user).id }
  end
end
