FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name[0,19] }
    email    { Faker::Internet.email }
    password "111111"
    confirmed_at DateTime.now
    status "offline"
    availability ""

    factory :inviter_user do
      transient do
        user FactoryGirl.create(:user)
      end
      after(:create) { |u, e| FactoryGirl.create(:friendship, user: u, friend: e.user) }
    end

    factory :invited_user do
      transient do
        user FactoryGirl.create(:user)
      end
      after(:create) { |u, e| FactoryGirl.create(:friendship, user: e.user, friend: u) }
    end

    factory :friend do
      transient do
        user FactoryGirl.create(:user)
      end
      after(:create) do |u, e|
        FactoryGirl.create(:friendship, user: u, friend: e.user)
        FactoryGirl.create(:friendship, user: e.user, friend: u)
      end
    end
  end
end
