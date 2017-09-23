FactoryGirl.define do
  factory :lesson do
    message "MyText"
    association :sender, factory: :user
    association :receiver, factory: :user
    association :subject, factory: :subject
    confirmed_at nil
    starts_at_time "13:06"
    starts_at_date "2017-09-21"
    ends_at_time "14:06"
    ends_at_date "2017-09-21"
  end
end
