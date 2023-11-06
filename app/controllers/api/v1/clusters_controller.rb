# frozen_string_literal: true

module Api
  module V1
    class ClustersController < Api::V1::ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_clusters, :manage_clusters }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_clusters }, only: %i[create update destroy]

      def index
        @clusters = Cluster.all

        @clusters.each do |cluster|
          ClusterChannel.broadcast_to(cluster, 'Test')
        end
        render json: @clusters
      end

      def show
        render json: @cluster
      end

      def create
        application = Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: 'https://localhost:8080')
        @cluster = Cluster.new(cluster_params)
        @cluster.oauth_application = application
        @cluster.save!
        Clusters::CreateClusterJob.perform_later(@cluster.id) if @cluster.managed?
        render json: @cluster, include: [:oauth_application]
      end

      def update; end
      def destroy; end

      def ping
        doorkeeper_token = ::Doorkeeper.authenticate(request)
        application_id = doorkeeper_token.application_id
        head :forbidden if application_id != @cluster.oauth_application_id

        @cluster.assign_attributes(ping_params)
        @cluster.agent_connected = true
        @cluster.agent_last_ping = DateTime.now
        @cluster.save!
        head :no_content
      end

      private

      def find_cluster
        @cluster = Cluster.find(params[:id])
      end

      def cluster_params
        params.require(:cluster).permit(:name, :region, :version, :provider, :connection_method, :managed, :host)
      end

      def ping_params
        params.require(:cluster).permit(:agent_version, :agent_identifier, :version, :provider, :region)
      end
    end
  end
end
