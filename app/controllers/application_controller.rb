class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  around_action :set_time_zone, if: :current_user

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email,
      :current_password, :avatar, :avatar_cache, :remove_avatar, :country, :city, :state,
      :time_zone, availability: availability_params)}
  end

  def availability_params
    [sunday: [:from, :to], monday: [:from, :to],
    tuesday: [:from, :to], wednesday: [:from, :to],
    thursday: [:from, :to], friday: [:from, :to],
    saturday: [:from, :to]]
  end

  def authenticate_admin!
    redirect_to subjects_url, notice: "Only for admins" unless current_user.admin?
  end

  private

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
