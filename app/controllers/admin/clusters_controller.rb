# frozen_string_literal: true

module Admin
  class ClustersController < AdminController
    def index
      @clusters = Cluster.all
    end

    def show
      @cluster = Cluster.find(params[:id])
      @projects = Project.where(cluster_id: @cluster.id)
    end

    def new
      @cluster = Cluster.new
    end

    def create
      @cluster = Cluster.new(cluster_params)
      if Clusters::CreateClusterService.new(@cluster).execute
        flash[:notice] = 'Cluster successfully created'
        redirect_to admin_cluster_url @cluster
      else
        flash[:notice] = @cluster.errors.full_messages
      end
    end

    private

    def cluster_params
      params.require(:cluster).permit(:name, :domain)
    end
  end
end
