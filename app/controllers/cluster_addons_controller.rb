# frozen_string_literal: true

class ClusterAddonsController < ApplicationController
  before_action :find_cluster_addon, except: %i[index new create]
  def index
    @addons = ClusterAddon.all
  end

  def show; end

  def edit; end

  def new; end

  def create; end

  def update; end

  def destroy; end

  private

  def find_cluster_addon
    @addon = ClusterAddon.find(param[:id])
  end
end
