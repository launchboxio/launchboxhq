# frozen_string_literal: true

class AgentsController < ApplicationController
  def index
    @clusters = Cluster.all
    @agents = @clusters.map(&:agents).flatten
  end
end
