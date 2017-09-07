require 'rails_helper'

RSpec.describe Interest, type: :model do
  subject { FactoryGirl.create(:interest) }

  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:subject) }
end
