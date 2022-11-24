# frozen_string_literal: true

class ClustersController < AuthenticatedController
  before_action :add_initial_breadcrumbs
  before_action :find_cluster, except: %i[index new import create]

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

    params[:addons]&.each do |addon, value|
      value == 'on' && (@cluster.addons << ClusterAddon.find(addon))
    end

    if @cluster.save
      redirect_to @cluster
    else
      redirect_to :back
    end
  end

  def update; end

  def delete; end

  private

  # TODO: Only pull clusters the user has access to
  def find_cluster
    @cluster = Cluster.find(params[:id])
  end

  def cluster_params
    params.require(:cluster).permit(:host, :token, :ca_crt, :name)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add 'Clusters', clusters_path
  end
end
