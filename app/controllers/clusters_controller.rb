class ClustersController < AuthenticatedController
  def index
    @clusters = Cluster.all
  end

  def show
    @cluster
  end

  def create
    @cluster = Cluster.new(params[:cluster])
    @cluster.user = current_user
    @cluster.save
  end

  def update

  end

  def delete

  end
end
