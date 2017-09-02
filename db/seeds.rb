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


3.times do |n|
  p subject = Subject.create!(name: "Subject#{n}")
  3.times do |k|
    p children  = subject.children.create!(name: "Subject#{n} #{k}")
    3.times do |m|
      p children.children.create!(name: "Subject#{n} #{k} #{m}")
    end
  end

end
