require 'rails_helper'

RSpec.describe Participating, type: :model do
  subject { FactoryGirl.create(:participating) }

  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:chatroom) }
end
