class AgentsController < ApplicationController
  def index
    @clusters = Cluster.all
    @agents = @clusters.map { |c| c.agents }.flatten
  end
end
