# frozen_string_literal: true

module Api
  module V1
    class VcsConnectionsController < ApiController
      def index
        render json: {
          vcs_connections: current_resource_owner.vcs_connections
        }
      end

      def show
        connection = current_resource_owner.vcs_connections.find(params[:id])
        head :not_found if connection.nil?

        render json: { vcs_connection: connection }
      end
    end
  end
end
