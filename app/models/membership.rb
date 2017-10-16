class Membership < ApplicationRecord
  enum role: {
    member: 0,
    moderator: 1,
    admin: 2
  }

  belongs_to :user
  belongs_to :organization

  validate :founder_should_be_admin, on: :update
  before_destroy :founder_cannot_leave_organization

  private

  def founder_cannot_leave_organization
    if user_id == organization.founder_id
      errors.add(:user_id, "Founder cannot leave organization")
      throw :abort
    end
  end

  def founder_should_be_admin
    errors.add(:user_id, "Founder should be admin") if user_id == organization.founder_id && role != "admin"
  end
end
