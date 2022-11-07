class ClustersController < AuthenticatedController
  before_action :add_initial_breadcrumbs
  def index
    @clusters = Cluster.all
  end

  def show
    @cluster = Cluster.find(params[:id])
    breadcrumbs.add @cluster.name, cluster_path
  end

  def new
    @cluster = Cluster.new
  end

  def import
    @cluster = Cluster.new
  end

  def create
    @cluster = Cluster.new(cluster_params)
    @cluster.user = current_user
    if @cluster.save
      if @action == "create"
        CreateClusterJob.perform_now(@cluster.id)
      elsif @action == "import"
        ImportClusterConfigurationJob.perform_now(@cluster.id)
      end
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
  def cluster_params
    params.require(:cluster).permit(:host, :token, :ca_crt, :name)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add "Clusters", clusters_path
  end
end
