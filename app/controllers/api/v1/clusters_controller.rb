# frozen_string_literal: true

module Api
  module V1
    class ClustersController < Api::V1::ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_clusters, :manage_clusters }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_clusters }, only: %i[create update destroy]

      def index
        @clusters = Cluster.all
        render json: @clusters
      end

      def show
        render json: @cluster
      end

      def create
        application = Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: "https://localhost:8080")
        @cluster = Cluster.new(cluster_params)
        @cluster.oauth_application = application
        @cluster.save!
        Clusters::CreateClusterJob.perform_later(@cluster.id) if @cluster.managed?
        render :json => @cluster, :include => [:oauth_application]
      end

      def update; end
      def destroy; end

      private

      def find_cluster
        @cluster = Cluster.find(params[:id])
      end

      def cluster_params
        params.require(:cluster).permit(:name, :region, :version, :provider, :connection_method, :managed, :host, :ca_crt, :token)
      end
    end
  end
end
