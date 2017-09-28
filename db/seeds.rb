require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)
25.times do |n|
  p User.create!(
    email: "email#{n}@gmail.com",
    name: "namee#{n}",
    password: "111111",
    confirmed_at: DateTime.now,
    status: 0,
    availability:{
      :sunday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :monday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :tuesday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :wednesday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :thursday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :friday=>{:from=>"01:00AM", :to=>"11:00PM"},
      :saturday=>{:from=>"01:00AM", :to=>"11:00PM"}
    }
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
