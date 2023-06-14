class ClustersController < ApplicationController
  before_action :find_cluster, except: %i[index new create]

  def index
    @clusters = Cluster.all
  end

  def show; end

  private
  def find_cluster
    @cluster = Cluster.find(params[:id])
  end
end
