FactoryGirl.define do
  factory :subject do
    name { Faker::Name.title }
  end
end
