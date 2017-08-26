class ChatroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_participant, only: [:show]

  def index
    @chatrooms = current_user.chatrooms
  end

  def show
    @messages = @chatroom.messages
  end

  def create
    user = User.find(params[:user_id])
    @chatroom = create_room(user) if user
    redirect_to @chatroom
  end

  private

    def authenticate_participant
      @chatroom = Chatroom.find(params[:id])
    end

    def create_room(user)
      chatroom = Chatroom.create
      chatroom.add_participant(user)
      chatroom.add_participant(current_user)
      chatroom
    end
end
