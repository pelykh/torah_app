FactoryGirl.define do
  factory :user do
    name                { Faker::Name.name }
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password            "111111"
    confirmed_at        DateTime.now
    status              "offline"
    country             "Ukraine"
    state               "Oblastb"
    city                "Kiev"
    moderator           false
    verified            false
    admin               false
    time_zone           "UTC"

    availability do
        a = []
        7.times do |i|
          range = Time.zone.parse("2017 2 october 12:00AM") + i.days..Time.zone.parse("2017 2 october 11:30PM") + i.days
          a << range
        end
        a
    end

    factory :admin do
      admin true
      name { "Admin " + Faker::Name.name }
      sequence(:email) { |n| "admin@gmail.com" }
    end

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

    factory :busy_user do
      name { "Busy " + Faker::Name.name }
      sequence(:email) { |n| "busy#{n}@gmail.com" }

      availability do
        a = []
        7.times do |i|
          range = Time.zone.parse("2017 2 october 12:00AM") + i.days..Time.zone.parse("2017 2 october 12:00AM") + i.days
          a << range
        end
        a
      end
    end
  end
end
