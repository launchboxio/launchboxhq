# frozen_string_literal: true

module Admin
  class ClustersController < AdminController
    def index
      @clusters = Cluster.all
    end

    def show
      @cluster = Cluster.find(params[:id])
    end

    def new
      @cluster = Cluster.new
    end

    def create
      # TODO: Wrap all these cluster creation
      # calls in a transaction to prevent
      # orphaning created applications
      application = Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: 'https://localhost:8080')
      @cluster = Cluster.new(cluster_params)
      @cluster.oauth_application = application
      if @cluster.save
        Clusters::CreateClusterJob.perform_async(@cluster.id) if @cluster.managed?
        # TODO: Fix our redirect here
        # undefined method `cluster_url'
        redirect_to @cluster
      else
        render 'new'
      end
    end

    private

    def cluster_params
      params.require(:cluster).permit(:name, :region, :version, :provider, :connection_method, :managed, :host)
    end
  end
end
