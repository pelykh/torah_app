class User < ApplicationRecord
  enum status: [ :offline, :online, :away ]

  has_many :interests
  has_many :participatings
  has_many :subjects, through: :interests
  has_many :chatrooms, through: :participatings
  has_many :messages

  validates :name, length: { in: 6..20 }


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
end
