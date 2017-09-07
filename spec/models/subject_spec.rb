require 'rails_helper'

RSpec.describe Subject, type: :model do
  subject { FactoryGirl.create(:subject) }

  it { should be_valid }

  it { should belong_to(:parent).class_name("Subject") }
  it { should have_many(:children).class_name("Subject").dependent(:destroy) }
  it { should have_many(:interests).dependent(:destroy) }
  it { should have_many(:users).through(:interests) }
end
