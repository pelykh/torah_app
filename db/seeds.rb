require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

10.times do |n|
  p User.create!(
    email: "email#{n}@gmail.com",
    name: "namee#{n}",
    password: "111111",
    confirmed_at: DateTime.now
  )
end


10.times do |n|
  Subject.create!(name: "Subject#{n}")
end
