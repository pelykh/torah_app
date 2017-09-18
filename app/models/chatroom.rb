class Chatroom < ApplicationRecord
  has_many :participatings, dependent: :destroy
  has_many :users, through: :participatings
  has_many :messages, dependent: :destroy

  def add_participant user
    return nil if participatings.find_by(user_id: user.id)
    participatings.create(user_id: user.id)
  end

  def self.find_by_participants(user_a, user_b)
    return nil unless user_a and user_b
    self.joins(:users).where("(users.id = ?)", user_a.id).select do |chat|
      chat.users.select{ |user| user.id == user_b.id }.any?
    end.first
  end

  def participants_name_without(user)
    name = ""
    users.each do |u|
      unless user == u
        name <<  u.name + " "
      end
    end
    return name
  end
end
