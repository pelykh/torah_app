require 'rails_helper'

RSpec.describe Interest, type: :model do
  subject { FactoryGirl.create(:interest) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:subject) }
end