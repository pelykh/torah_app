class Notification < ApplicationRecord
  scope :unread, -> { where(read_at: nil) }
  belongs_to :user

  after_commit :broadcast_notification

  private

  def broadcast_notification
    ActionCable.server.broadcast "current_user_#{user_id}_channel",
                                 notification: render_notification(self)
  end

  def render_notification(notification)
      ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
  end
end
