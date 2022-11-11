class ClusterAddonsController < ApplicationController
  before_action :get_cluster_addon, except: [:index, :new, :create]
  def index
    @addons = ClusterAddon.all
  end

  def show

  end

  def edit

  end

  def new

  end

  def create

  end

  def update

  end

  def destroy

  end

  private
  def get_cluster_addon
    @addon = ClusterAddon.find(param[:id])
  end
end
