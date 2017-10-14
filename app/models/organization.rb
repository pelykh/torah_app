class Organization < ApplicationRecord
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  belongs_to :founder, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true
  validates :headline, presence: true
  validates :description, presence: true

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :banner, BannerUploader
end
