# frozen_string_literal: true

class ClustersController < ApplicationController
  before_action :find_cluster, except: %i[index new create]

  def index
    @clusters = Cluster.all
  end

  def new; end

  def create
    @cluster = Cluster.new(cluster_params)
    if Clusters::CreateClusterService.new(@cluster).execute
      flash[:notice] = 'Cluster successfully created'
      redirect_to admin_cluster_url @cluster
    else
      flash[:notice] = @cluster.errors.full_messages
    end
  end

  def show; end

  private

  def find_cluster
    @cluster = Cluster.find(params[:id])
  end
end
