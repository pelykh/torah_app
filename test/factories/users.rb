FactoryGirl.define do
  factory :user do
    name "ValidName"
    email "email@gmail.com"
    password "111111"
    confirmed_at DateTime.now
  end
end
