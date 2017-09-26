FactoryGirl.define do
  factory :lesson do
    message "MyText"
    association :sender, factory: :user
    association :receiver, factory: :user
    association :subject, factory: :subject
    confirmed_at DateTime.now
    starts_at_time Time.now + 1.hours
    starts_at_date  Date.today
    ends_at_time Time.now + 2.hours
    ends_at_date Date.tomorrow
    recurring false
  end
end
