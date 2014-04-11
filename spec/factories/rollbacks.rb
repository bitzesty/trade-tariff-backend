FactoryGirl.define do
  factory :rollback do
    date { Date.today }
    reason { SecureRandom.hex }
    user_id { create(:user).id }
  end
end
