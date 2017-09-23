FactoryGirl.define do
  factory :lesson do
    message "MyText"
    association :sender, factory: :user
    association :receiver, factory: :user
    association :subject, factory: :subject
    starts_at "2017-09-21 13:06:06"
    ends_at "2017-09-21 13:06:06"
    confirmed_at "2017-09-21 13:06:06"
  end
end
