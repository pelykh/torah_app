class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email,
      :current_password, :avatar, :avatar_cache, :remove_avatar, availability: availability_params) }
  end

  def availability_params
    [sunday: [:from, :to], monday: [:from, :to],
    tuesday: [:from, :to], wednesday: [:from, :to],
    thursday: [:from, :to], friday: [:from, :to],
    saturday: [:from, :to]]
  end
end
