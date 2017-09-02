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
      redirect_to subjects_url, notice: 'Subject was successfully added to your favorites.'
    else
      redirect_to subjects_url, notice: 'You already have added that subject to your favorites.'
    end
  end

  def remove_subject
    subject = Subject.find(params[:id])
    interest = current_user.interests.find_by(subject_id: subject.id)
    if interest
      interest.destroy
      redirect_to subjects_url, notice: 'Subject was successfully deleted from your favorites.'
    else
      redirect_to subjects_url, notice: 'You already have alreay deleted that subject from your favorites.'
    end
  end

  private

  def user_params
    pararm.require(:user).permit(:email, :password, :password_confirmation)
  end

end
