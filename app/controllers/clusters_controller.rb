class ClustersController < ApplicationController
  before_action :find_cluster, except: %i[index new create]

  def index
    @clusters = Cluster.all
  end

  def new; end
  def create
    application = Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: "https://localhost:8080")
    @cluster = Cluster.new(cluster_params)
    @cluster.oauth_application = application
    @cluster.save!
    Clusters::CreateClusterJob.perform_later(@cluster.id) if @cluster.managed?
    render :json => @cluster, :include => [:oauth_application]
  end

  def show; end

  private
  def find_cluster
    @cluster = Cluster.find(params[:id])
  end
end
