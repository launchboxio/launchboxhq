# frozen_string_literal: true

module Api
  module V1
    class ClustersController < Api::V1::ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_clusters, :manage_clusters }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_clusters }, only: %i[create destroy]

      # Only allow admins unless listing or retrieving clusters
      before_action -> { require_admin! }, except: %i[index show update]
      before_action -> { :authorize_cluster_access }, only: %i[update]

      def index
        @clusters = Cluster.all
        render json: { clusters: @clusters }
      end

      def show
        if current_resource_owner.admin?
          render json: { cluster: @cluster }, include: [:oauth_application]
        else
          render json: { cluster: @cluster }
        end
      end

      def create
        @cluster = Cluster.new(cluster_params)
        if Clusters::CreateClusterService.new(@cluster).execute
          render json: @cluster, include: [:oauth_application]
        else
          render json: {
            errors: @cluster.errors.full_messages
          }, status: 400
        end
      end

      def update
        doorkeeper_token = ::Doorkeeper.authenticate(request)
        application_id = doorkeeper_token.application_id
        head :forbidden if application_id != @cluster.oauth_application_id

        @cluster.assign_attributes(update_params)
        if cluster_request?
          @cluster.agent_connected = true
          @cluster.agent_last_ping = DateTime.now
        end
        @cluster.save!
        render json: { cluster: @cluster }
      end

      def destroy
        @cluster.destroy!
        head :no_content
      end

      private

      def find_cluster
        @cluster = Cluster.find(params[:id])
      end

      def cluster_params
        params.require(:cluster).permit(:name, :domain)
      end

      def update_params
        params.require(:cluster).permit(:agent_version, :agent_identifier, :version, :provider, :region, :domain, :status)
      end

      def authorize_cluster_access
        doorkeeper_token = ::Doorkeeper.authenticate(request)
        head :unauthorized and return if doorkeeper_token.nil?

        if cluster_request?
          cluster = Cluster.where(oauth_application_id: doorkeeper_token.application_id)
          head :forbidden if cluster.nil? || (cluster.id != @cluster.id)
        else
          require_admin!
          doorkeeper_authorize! :manage_clusters
        end
      end
    end
  end
end
