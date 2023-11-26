# frozen_string_literal: true

class OrganizationsController < AuthenticatedController
  before_action :find_organization, only: %i[show update destroy edit]
  def index
    @organizations = current_user.organizations
  end

  def show; end

  def new
    @organizations = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.create_and_add_user(current_user)
      flash[:notice] = 'Organization successfully created'
      redirect_to @organization
    else
      flash[:notice] = @organization.errors.full_messages
      render 'new'
    end
  end

  def update; end

  def destroy; end

  private

  def find_organization
    @organization = current_user.organizations.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :company, :email, :plan)
  end
end
