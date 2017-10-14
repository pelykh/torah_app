class OrganizationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_organization, only: [:show]

  def index
    @organizations = Organization.confirmed
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.foundations.build(organization_params)
    if @organization.save
      redirect_to organizations_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(
      :name, :headline, :description, :banner, :thumbnail, :thumbnail_cache,
      :remove_thumbnail, :banner_cache, :remove_banner)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
