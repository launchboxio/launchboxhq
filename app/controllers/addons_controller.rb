# frozen_string_literal: true

class AddonsController < AuthenticatedController
  before_action :find_addon, except: %i[index new create]

  def index
    @addons = Addon.all
  end

  def show; end

  private

  def find_addon
    @addon = Addon.find(params[:id])
  end
end
