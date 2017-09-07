require 'rails_helper'

RSpec.describe Friendship, type: :model do
  subject { FactoryGirl.create(:friendship) }

  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:friend).class_name("User") }
end
