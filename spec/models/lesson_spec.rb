require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { FactoryGirl.build(:lesson) }

  it { is_expected.to be_valid }

  it { is_expected.to respond_to :message }
  it { is_expected.to respond_to :starts_at }
  it { is_expected.to respond_to :ends_at }
  it { is_expected.to respond_to :sender_id }
  it { is_expected.to respond_to :receiver_id }
  it { is_expected.to respond_to :subject_id }
  it { is_expected.to respond_to :confirmed_at }
  it { is_expected.to respond_to :recurring }

  describe ".check_if_time_range_is_valid" do
    context "when time range is valid" do
      it { is_expected.to be_valid }
    end

    context "when time range is invalid" do
      it "raises error" do
        subject.starts_at_time = subject.ends_at_time + 3.hours
        subject.starts_at_date = subject.ends_at_date
        is_expected.to be_invalid
        expect(subject.errors[:starts_at]).to include("is invalid")
        expect(subject.errors[:ends_at]).to include("is invalid")
      end
    end

    context "when time range starts on past days" do
      it "raises error" do
        subject.starts_at_date =  Date.yesterday
        is_expected.to be_invalid
        expect(subject.errors[:starts_at]).to include("You can`t set up lesson on  past days")
      end
    end
  end

  describe ".check_if_users_have_lessons_at_time_range" do
    context "when here is lesson on the same time" do
      it "returns errors" do
        FactoryGirl.create(:lesson, subject.as_json)
        is_expected.to be_invalid
        expect(subject.errors[:starts_at]).to include("#{subject.receiver.name} is busy at that time")
      end
    end

    context "when here is recurring lesson" do
      context "when time range is in lesson time" do
        it "returns error" do
          FactoryGirl.create(:lesson, receiver: subject.receiver, sender: subject.sender,
            starts_at_date: Date.today - 7.days, ends_at_date: Date.today - 7.days, recurring: true)
          is_expected.to be_invalid

          expect(subject.errors[:starts_at]).to include("#{subject.receiver.name} is busy at that time")
          expect(subject.errors[:starts_at]).to include("#{subject.sender.name} is busy at that time")
        end
      end

      context "when time range is not in lesson time" do
      end
    end

    context "when here is another lesson between time range" do
      context "when other lesson doesn't confirmed" do
        before do
          FactoryGirl.create(:lesson, receiver_id: subject.receiver_id,
            starts_at_time: Time.now + 1.hours, ends_at_date: Date.today, confirmed_at: nil)
          end

        it { is_expected.to be_valid }
      end

      context "when receiver has lesssons" do
        it "returns errors" do
          FactoryGirl.create(:lesson, receiver_id: subject.receiver_id,
            starts_at_time: Time.now + 1.hours, ends_at_date: Date.today)
          is_expected.to be_invalid
          expect(subject.errors[:starts_at]).to include("#{subject.receiver.name} is busy at that time")
        end
      end

      context "when sender has lesssons" do
        it "returns errors" do
          FactoryGirl.create(:lesson, sender_id: subject.sender_id,
            starts_at_time: Time.now + 1.hours, ends_at_date: Date.today)
          is_expected.to be_invalid
          expect(subject.errors[:starts_at]).to include("#{subject.sender.name} is busy at that time")
        end
      end
    end

    context "when there is no lessons between on the same time" do
      it { is_expected.to be_valid }
    end
  end

  describe ".check_if_users_are_available" do
    context "when sender is unavailable" do
      it "returns error" do
        subject.sender = FactoryGirl.create(:busy_user)
        is_expected.to be_invalid
        expect(subject.errors[:starts_at]).to include("#{subject.sender.name} is unavailable at that time")
      end
    end

    context "when receiver is unavailable" do
      it "returns error" do
        subject.receiver = FactoryGirl.create(:busy_user)
        is_expected.to be_invalid
        expect(subject.errors[:starts_at]).to include("#{subject.receiver.name} is unavailable at that time")
      end
    end

    context "when both users are available" do
      it { is_expected.to be_valid }
    end
  end
end
