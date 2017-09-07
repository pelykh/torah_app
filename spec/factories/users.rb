FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password "111111"
    confirmed_at DateTime.now
    status 0
  end
end
