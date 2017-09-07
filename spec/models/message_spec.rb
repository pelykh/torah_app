require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { FactoryGirl.build(:message) }

  it { should be_valid }

  it { should respond_to(:body) }

  it { should belong_to(:user) }
  it { should belong_to(:chatroom) }

  it { should validate_length_of(:body).is_at_least(1).is_at_most(200) }
  it { should validate_presence_of(:body) }

  it "runs MessageBroadcastJob on after_commit" do
    expect { subject.save }.to have_enqueued_job(MessageBroadcastJob).exactly(:once)
  end
end
