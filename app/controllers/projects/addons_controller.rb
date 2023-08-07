module Projects
  class AddonsController < Projects::ApplicationController
    before_action :find_addon, only: %i[show edit update destroy]
    def index
      @addons = @project.addon_subscriptions
    end

    def show; end
    def edit; end
    def new
      @addon = @project.addon_subscriptions.build
    end
    def update; end
    def create; end
    def destroy; end

    private

    def find_addon
      @addon = @project.addon_subscriptions.find(params[:id])
    end
  end
end
