# frozen_string_literal: true

class ServicesController < AuthenticatedController
  before_action :find_service, only: %i[show update destroy]

  def index
    @services = current_user.services
  end

  def show; end

  def new
    @service = current_user.services.build
  end

  def create
    @service = current_user.services.new(service_params)
    if Services::CreateService.new(@service).execute
      flash[:notice] = 'Service added'
      redirect_to services_path(@service)
    else
      flash[:notice] = @service.errors.full_messages
      render 'new'
    end
  end

  private

  def find_service
    @service = current_user.services.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:vcs_connection_id, :full_name)
  end
end
