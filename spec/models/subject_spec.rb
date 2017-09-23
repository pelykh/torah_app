require 'rails_helper'

RSpec.describe Subject, type: :model do
  subject { FactoryGirl.create(:subject) }

  it { is_expected.to be_valid }

  it { is_expected.to respond_to :name }

  it { is_expected.to belong_to(:parent).class_name("Subject") }
  it { is_expected.to have_many(:children).class_name("Subject").dependent(:destroy) }
  it { is_expected.to have_many(:interests).dependent(:destroy) }
  it { is_expected.to have_many(:lessons).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:interests) }
end
