class User < ApplicationRecord
  scope :online, -> { where(status: "online") }

  enum status: {
    offline: 0,
    online: 1,
    away: 2
  }

  has_many :interests, dependent: :destroy
  has_many :participatings
  has_many :subjects, through: :interests
  has_many :chatrooms, through: :participatings
  has_many :messages
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :name, presence: true, length: { in: 6..20 }

  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :lockable, :omniauthable

  def disappear
    update_attribute(:status, 0)
  end

  def appear
    update_attribute(:status, 1)
  end

  def away
    update_attribute(:status, 2)
  end

  def relation_with user
    has_invited_user = Friendship.find_by(user_id: id, friend_id: user.id)
    invited_by_user = Friendship.find_by(user_id: user.id, friend_id: id)
    return "friends" if has_invited_user && invited_by_user
    return "invited_user" if has_invited_user && !invited_by_user
    return "invited_by_user" if !has_invited_user && invited_by_user
    return "not_friends" if !has_invited_user && !invited_by_user
  end
end
