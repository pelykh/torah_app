require 'database_cleaner'
require 'factory_girl_rails'


DatabaseCleaner.clean_with(:truncation)

5.times do |n|
  FactoryGirl.create(:user)
end

5.times do |n|
  FactoryGirl.create(:busy_user)
end

FactoryGirl.create(:admin)

3.times do |n|
  subject = Subject.create!(name: "Subject#{n}", headline: "headline", description: "description")
  3.times do |k|
    children  = subject.children.create!(name: "Subject#{n} #{k}", headline: "headline", description: "description")
    3.times do |m|
      children.children.create!(name: "Subject#{n} #{k} #{m}", headline: "headline", description: "description")
    end
  end

end
