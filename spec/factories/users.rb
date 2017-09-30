FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name[0,19] }
    email    { Faker::Internet.email }
    password "111111"
    confirmed_at DateTime.now
    status "offline"
    country "Ukraine"
    state "Oblastb"
    city "Kiev"
    availability do
      {
        :sunday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :monday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :tuesday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :wednesday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :thursday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :friday=>{:from=>"01:00AM", :to=>"11:00PM"},
        :saturday=>{:from=>"01:00AM", :to=>"11:00PM"}
      }
    end

    factory :admin do
      admin true
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
      availability do
        {
          :sunday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :monday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :tuesday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :wednesday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :thursday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :friday=>{:from=>"12:00AM", :to=>"12:00AM"},
          :saturday=>{:from=>"12:00AM", :to=>"12:00AM"}
        }
      end
    end
  end
end
