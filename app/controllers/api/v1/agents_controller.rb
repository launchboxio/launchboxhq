# frozen_string_literal: true

module Api
  module V1
    class AgentsController < ActionController::API
      respond_to :json
      before_action -> { doorkeeper_authorize! :agent }
      before_action :find_cluster
      before_action :verify_agent_token
      def create
        @agent = @cluster.agents.build(agent_params)
        @agent.last_communication = DateTime.now

        return unless @agent.save

        render json: @agent, status: :ok
      end

      private

      def find_cluster
        @cluster = Cluster.find(params[:cluster_id])
      end

      def agent_params
        params.require(:agent).permit(:pod_name, :node_name, :ip_address)
      end

      def verify_agent_token
        @cluster.oauth_application.id == doorkeeper_token.application_id
      end

      def missing_agent_token_error
        render json: { error: 'Please provide an agent token', code: 401 }, status: :unauthorized
      end
    end
  end
end
