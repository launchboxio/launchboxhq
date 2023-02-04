# frozen_string_literal: true

class AgentsController < ApplicationController
  def index
    @clusters = Cluster.all
    @agents = @clusters.map(&:agents).flatten
  end

  def show; end

  def new; end
end
