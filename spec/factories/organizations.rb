FactoryGirl.define do
  factory :organization do
    name { Faker::Name.title }
    headline { Faker::Name.title }
    description { Faker::Name.title }
    confirmed_at Time.current
    association :founder, factory: :user
    banner nil
    thumbnail nil
  end
end
