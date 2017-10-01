class Subject < ApplicationRecord
  has_many :interests, dependent: :destroy
  has_many :users, through: :interests
  belongs_to :parent, class_name: "Subject", optional: true
  has_many :children, class_name: "Subject", foreign_key: :parent_id, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, presence: true
  validates :headline, presence: true
  validates :description, presence: true

  validate :check_if_parent_id_wont_loop, on: :update

  mount_uploader :thumbnail, ThumbnailUploader
  mount_uploader :banner, BannerUploader

  def is_inherit_from_child?(id)
    self.children.each do |c|
      return true if c.id == id || c.is_inherit_from_child?(id)
    end
    return false
  end

  private

  def check_if_parent_id_wont_loop
    errors.add(:parent_id, "You cannot inherit subject from himself") if parent_id == id
    errors.add(:parent_id, "You cannot inherit subject from his child") if parent_id && is_inherit_from_child?(parent_id)
  end
end
