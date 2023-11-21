# frozen_string_literal: true

class ServicesController < AuthenticatedController
  before_action :find_repository, except: %i[index]
  before_action :find_service, only: %i[show update destroy]

  def index
    @services = current_user.services
  end

  def show; end

  def new
    @service = @repository.services.build
  end

  def create
    @service = @repository.services.new(service_params)
    if @service.save
      flash[:notice] = 'Service added'
      redirect_to repository_path(@repository)
    else
      flash[:notice] = @service.errors.full_messages
      render 'new'
    end
  end

  def destroy
    @service.destroy
    redirect_to repository_path(@repository)
  end

  private

  def find_repository
    @repository = current_user.repositories.find(params[:repository_id])
  end

  def find_service
    @service = @repository.services.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :deployment_strategy, :update_strategy)
  end
end
