require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { FactoryGirl.create(:lesson) }

  it { is_expected.to be_valid }

  it { is_expected.to respond_to :message }
  it { is_expected.to respond_to :starts_at }
  it { is_expected.to respond_to :ends_at }
  it { is_expected.to respond_to :sender_id }
  it { is_expected.to respond_to :receiver_id }
  it { is_expected.to respond_to :subject_id }
  it { is_expected.to respond_to :confirmed_at }
end
