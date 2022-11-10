class Api::V1::AgentsController < ActionController::API
  respond_to :json
  before_action :get_cluster

  def create
    token = params[:token]
    if @cluster.agent_token != token
      render json: {status: "error", code: 400}, status: :bad_request
    else
      @agent = @cluster.agents.build(agent_params)
      @agent.last_communication = DateTime.now
      @agent.save!
      render json: @agent, status: :ok
    end
  end

  def destroy

  end

  private
  def get_cluster
    @cluster = Cluster.find(params[:cluster_id])
  end

  def agent_params
    params.require(:agent).permit(:pod_name, :node_name, :ip_address)
  end
end
