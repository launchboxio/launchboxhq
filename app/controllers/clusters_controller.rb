class ClustersController < ApplicationController
  def index
    @clusters = Cluster.all
    render :json => @clusters
  end

  def show
    render :json => @cluster
  end
end
