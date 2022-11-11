class ClustersController < AuthenticatedController
  before_action :add_initial_breadcrumbs
  before_action :get_cluster, except: [:index, :new, :import, :create]

  def index
    @clusters = Cluster.all
  end

  def show
    breadcrumbs.add @cluster.name, cluster_path
  end

  def new
    @cluster = Cluster.new
  end

  def create
    @cluster = Cluster.new(cluster_params)
    @cluster.user = current_user

    if params[:addons]
      params[:addons].each do |addon, value|
        value == "on" && @space.addons << Addon.find(addon)
      end
    end

    if @cluster.save
      redirect_to @cluster
    else
      redirect_to :back
    end
  end

  def update

  end

  def delete

  end

  private
  # TODO: Only pull clusters the user has access to
  def get_cluster
    @cluster = Cluster.find(params[:id])
  end

  def cluster_params
    params.require(:cluster).permit(:host, :token, :ca_crt, :name)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add "Clusters", clusters_path
  end
end
