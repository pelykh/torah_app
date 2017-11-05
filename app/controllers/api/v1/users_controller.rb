class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :wrong_user_id

  def index
    @users = User.filter(filters_params).search(search_params).page(params[:page])
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user, serializer: UserProfileSerializer
  end

  def add_to_friends
    user = User.find(params[:user_id])
    current_user.friendships.create(friend_id: user.id)
    head :created
  end

  def remove_from_friends
    user = User.find(params[:user_id])
    current_user.friendships.find_by(friend_id: user.id).destroy
    head :no_content
  end

  private

  def wrong_user_id
    render json: { errors: [ id: "Wrong user id provided"] }
  end

  def filters_params
    params[:filters]? params.require(:filters).permit(:sort, :online, :order_by) : {}
  end

  def search_params
    params[:search]? params.require(:search).permit(:name, :country, :city, :state) : {}
  end
end
