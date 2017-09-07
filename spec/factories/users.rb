FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name[0,19] }
    email    { Faker::Internet.email }
    password "111111"
    confirmed_at DateTime.now
    status 0
  end
end
