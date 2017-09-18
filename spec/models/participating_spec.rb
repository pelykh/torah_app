require 'rails_helper'

RSpec.describe Participating, type: :model do
  subject { FactoryGirl.create(:participating) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:chatroom) }
end
