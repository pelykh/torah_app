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

  def subscribe
    head :ok
  end

  def create
    Webpush.payload_send(
    message: notification_message,
    endpoint: params[:subscription][:endpoint],
    p256dh: params[:subscription][:keys][:p256dh],
    auth: params[:subscription][:keys][:auth],
    click_action: "/chatrooms",
    vapid: {
      subject: "/",
      public_key: ENV['VAPID_PUBLIC_KEY'],
      private_key: ENV['VAPID_PRIVATE_KEY']
      }
    )

    head :ok
  end

  private

  def notification_message
    {
      body: params[:message],
      url: chatrooms_url
    }.to_json
  end
end
