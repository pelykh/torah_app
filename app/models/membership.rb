class Membership < ApplicationRecord
  enum role: {
    member: 0,
    moderator: 1,
    admin: 2
  }

  belongs_to :user
  belongs_to :organization
end
