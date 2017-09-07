class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :body, presence: true, length: { in: 1..200 }

  after_commit { MessageBroadcastJob.perform_later(self) }
end
