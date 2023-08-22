class ResourcesController < AuthenticatedController
  before_action :find_resource, except: %i[index new create]
  def index
    @resources = current_user.resources
  end

  def new
    @resource = current_user.resources.build
  end

  def edit; end
  def show; end

  def create
    params = resource_params
    connection = current_user.vcs_connections.find(params[:vcs_connection_id])
    @resource = current_user.resources.build
    @resource.vcs_connection_id = connection.id
    @resource.repository = params[:repository]
    if @resource.save
      redirect_to @resource
    else
      render 'new'
    end
  end

  def update; end

  def destroy
    @resource.destroy!
    redirect_to resources_path
  end

  private
  def find_resource
    @resource = Resource.find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(:repository, :vcs_connection_id)
  end
end
