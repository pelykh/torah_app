class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:add_subject]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @chatroom = Chatroom.find_by_participants(current_user, @user)
  end

  def add_subject
    subject = Subject.find(params[:id])
    interest = current_user.interests.find_by(subject_id: subject.id)
    unless interest
      Interest.create(user_id: current_user.id, subject_id: subject.id)
      head :created and return
    else
      head :bad_request and return
    end
  end

  def remove_subject
    subject = Subject.find(params[:id])
    interest = current_user.interests.find_by(subject_id: subject.id)
    if interest
      interest.destroy
      head :no_content and return
    else
      head :bad_request and return
    end
  end

  def add_friend
    user = User.find(params[:id])
    if user
      current_user.friendships.create(friend_id: user.id)
      redirect_to user
    end
  end

  def remove_friend
    user = User.find(params[:id])
    if user
      current_user.friendships.find_by(friend_id: user.id).destroy
      redirect_to user
    end
  end

  private

  def user_params
    pararm.require(:user).permit(:email, :password, :password_confirmation)
  end

end
