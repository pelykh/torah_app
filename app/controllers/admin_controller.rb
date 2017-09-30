class AdminController < ApplicationController
  before_action :authenticate_admin!

  def edit_user
    @user = User.find(params[:id])
  end

  def update_user
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:moderator, :verified)
  end
end
