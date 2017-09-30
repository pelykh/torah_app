require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)
25.times do |n|
  User.create!(
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

User.create!(
  email: "admin@gmail.com",
  name: "Adminnnn",
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
  },
  admin: true
)




3.times do |n|
  subject = Subject.create!(name: "Subject#{n}", headline: "headline", description: "description")
  3.times do |k|
    children  = subject.children.create!(name: "Subject#{n} #{k}", headline: "headline", description: "description")
    3.times do |m|
      children.children.create!(name: "Subject#{n} #{k} #{m}", headline: "headline", description: "description")
    end
  end

end
