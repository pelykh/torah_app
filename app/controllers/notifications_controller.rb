class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:limit]
      @notifications = current_user.notifications.limit(params[:limit])
    else
      @notifications = current_user.notifications.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json { p render json: @notifications }
    end
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy if @notification
    redirect_to notifications_url
  end

  def mark_as_read
    @notifications = current_user.notifications.unread
    @notifications.update_all(read_at: Time.current)
    render json: { success: true }
  end
end
