require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  let(:invited_user) do
    subject.save
    invited_user = FactoryGirl.create(:user)
    FactoryGirl.create(:friendship, user: subject, friend: invited_user)
    invited_user
  end

  let(:friend) do
    subject.save
    friend = FactoryGirl.create(:user)
    FactoryGirl.create(:friendship, user: subject, friend: friend)
    FactoryGirl.create(:friendship, user: friend, friend: subject)
    friend
  end

  let(:not_friend) do
    subject.save
    FactoryGirl.create(:user)
  end

  let(:inviter_user) do
    subject.save
    inviter_user = FactoryGirl.create(:user)
    FactoryGirl.create(:friendship, user: inviter_user, friend: subject)
    inviter_user
  end

  it { should be_valid }

  it { should respond_to :name }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(6).is_at_most(20) }

  it { should respond_to :email }

  it { should have_many(:interests).dependent(:destroy) }
  it { should have_many(:participatings) }
  it { should have_many(:subjects).through(:interests) }
  it { should have_many(:chatrooms).through(:participatings) }
  it { should have_many(:messages) }
  it { should have_many(:friendships).dependent(:destroy) }
  it { should have_many(:friends).through(:friendships) }

  it { should define_enum_for(:status).with({ offline: 0, online: 1, away: 2 }) }

  it "returns online users on online scope" do
    FactoryGirl.create(:user)
    FactoryGirl.create(:user, status: "online")
    expect(User.online.count).to eql(1)
  end

  it "changes status to online on appear" do
     expect{subject.appear}.to change{subject.status}.from("offline").to("online")
  end

  it "changes status to offline on disappear" do
     subject.status = "online"
     expect{subject.disappear}.to change{subject.status}.from("online").to("offline")
  end

  it "changes status to away on away" do
     expect{subject.away}.to change{subject.status}.from("offline").to("away")
  end

  context "returns relation with other user on relation_with" do
    context "when you invited user" do
      it "returns invited_user" do
        expect(subject.relation_with(invited_user)).to eql("invited_user")
      end
    end

    context "when you invited by user" do
      it "returns invited_user" do
        expect(subject.relation_with(inviter_user)).to eql("invited_by_user")
      end
    end

    context "when you are friends" do
      it "returns friend" do
        expect(subject.relation_with(friend)).to eql("friends")
      end
    end

    context "when you aren't friends" do
      it "returns not_friend" do
        expect(subject.relation_with(not_friend)).to eql("not_friends")
      end
    end
  end
end
