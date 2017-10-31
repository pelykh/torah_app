class CurrentUserChannel < ApplicationCable::Channel

  def subscribed
    p "user #{current_user.id} is subscribed"
    stream_from "current_user_#{current_user.id}_channel"
    current_user.appear
  end

  def unsubscribed
    current_user.disappear
  end

  def away
    current_user.away
  end
end
