# frozen_string_literal: true

module Api
  module V1
    class AgentsController < ActionController::API
      respond_to :json
      before_action :cluster
      before_action :verify_agent_token

      def create
        @agent = @cluster.agents.build(agent_params)
        @agent.last_communication = DateTime.now
        if @agent.save
          render json: @agent, status: :ok
        else
          render json: { status: 'error', code: 400 }, status: :bad_request
        end
      end

      def destroy; end

      private

      def cluster
        @cluster = Cluster.find(params[:cluster_id])
      end

      def agent_params
        params.require(:agent).permit(:pod_name, :node_name, :ip_address)
      end

      def verify_agent_token
        return missing_agent_token_error unless params[:token]

        return invalid_agent_token_error unless params[:token] == @cluster.agent_token
      end

      def missing_agent_token_error
        render json: { error: 'Please provide an agent token', code: 401 }, status: :unauthorized
      end

      def invalid_agent_token_error
        render json: { error: 'Invalid agent token found', code: 403 }, status: :forbidden
      end
    end
  end
end
