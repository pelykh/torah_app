require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.create(:user) }

  let(:invited_user) { FactoryGirl.create(:invited_user, user: subject) }

  let(:friend) { FactoryGirl.create(:friend, user: subject) }

  let(:not_friend) { FactoryGirl.create(:user) }

  let(:inviter_user) { FactoryGirl.create(:inviter_user, user: subject) }

  it { is_expected.to be_valid }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :availability }
  it { is_expected.to respond_to :admin }
  it { is_expected.to respond_to :country }
  it { is_expected.to respond_to :city }
  it { is_expected.to respond_to :state }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(6).is_at_most(20) }

  it { is_expected.to have_many(:interests).dependent(:destroy) }
  it { is_expected.to have_many(:participatings) }
  it { is_expected.to have_many(:subjects).through(:interests) }
  it { is_expected.to have_many(:chatrooms).through(:participatings) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:friendships).dependent(:destroy) }
  it { is_expected.to have_many(:friends).through(:friendships) }
  it { is_expected.to have_many(:lessons).dependent(:destroy) }

  it { is_expected.to define_enum_for(:status).with({ offline: 0, online: 1, away: 2 }) }

  it "returns online users on online scope" do
    FactoryGirl.create(:user)
    FactoryGirl.create(:user, status: "online")
    expect(User.online.count).to eql(1)
  end

  describe "sort scope" do
    it "returns newest users on newest" do
      2.times { FactoryGirl.create(:user) }
      expect(User.sort("newest").first).to eql(User.last)
    end

    it "return oldest users on oldest" do
      2.times { FactoryGirl.create(:user) }
      expect(User.sort("oldest").first).to eql(User.first)
    end
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

  describe "#is_available?" do
    context "when user is available now" do
      it "returns true" do
        subject.availability = {
          sunday:    { from: "12:00am", to: "11:30pm" },
          monday:    { from: "12:00am", to: "11:30pm" },
          tuesday:   { from: "12:00am", to: "11:30pm" },
          wednesday: { from: "12:00am", to: "11:30pm" },
          thursday:  { from: "12:00am", to: "11:30pm" },
          friday:    { from: "12:00am", to: "11:30pm" },
          saturday:  { from: "12:00am", to: "11:30pm" }
        }
        expect(subject.is_available?).to be_truthy
      end
    end
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
