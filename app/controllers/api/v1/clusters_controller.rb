class Api::V1::ClustersController < Api::V1::ApiController
  def index
    @clusters = Cluster.all
    render :json => @clusters
  end

  def show

  end
end
