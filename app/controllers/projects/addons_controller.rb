# frozen_string_literal: true

module Projects
  class AddonsController < Projects::ApplicationController
    before_action :find_addon, only: %i[show edit update destroy]
    def index
      @addons = @project.addon_subscriptions
    end

    def show; end
    def edit; end

    def new
      @addons = Addon.all
      @addon = @project.addon_subscriptions.build
    end

    def update; end

    def create
      @sub = @project.addon_subscriptions.build(addon_params)
      if @sub.save
        Projects::ProjectSyncService.new(@project).execute
        redirect_to project_path(@project), notice: 'Addon attached'
      else
        flash[:notice] = @sub.errors.full_messages.to_sentence
        render 'new'
      end
    end

    def destroy
      @subscription = @project.addon_subscriptions.find(params[:id])
      @subscription.destroy
      Projects::ProjectSyncService.new(@project).execute
      redirect_to project_path(@project), notice: 'Addon removed'
    end

    private

    def find_addon
      @addon = @project.addon_subscriptions.find(params[:id])
    end

    def addon_params
      params.require(:addon_subscription).permit(:name, :addon_id, :name)
    end
  end
end
