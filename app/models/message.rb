class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  after_commit { MessageBroadcastJob.perform_later(self) }
end
