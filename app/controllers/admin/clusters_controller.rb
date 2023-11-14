# frozen_string_literal: true

module Admin
  class ClustersController < AdminController
    before_action :find_cluster, only: %i[show edit update destroy]
    def index
      @clusters = Cluster.all
    end

    def show
      @projects = Project.where(cluster_id: @cluster.id)
    end

    def edit; end

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

    def update
      if @cluster.update(update_params)
        flash[:notice] = 'Cluster updated'
        redirect_to admin_cluster_url @cluster
      else
        flash[:notice] = @cluster.errors.full_messages
        render 'edit'
      end
    end

    private

    def find_cluster
      @cluster = Cluster.find(params[:id])
    end

    def cluster_params
      params.require(:cluster).permit(:name, :domain)
    end

    def update_params
      params.require(:cluster).permit(:name, :domain, :status)
    end
  end
end
