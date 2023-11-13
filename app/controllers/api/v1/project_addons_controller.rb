# frozen_string_literal: true

module Api
  module V1
    class ProjectAddonsController < ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create]
      before_action :find_project
      before_action :find_subscription, except: %i[index create]

      before_action -> { :authorize_project_access }, only: %i[update]

      def index
        @addons = AddonSubscription.where(project_id: @project.id)
        render json: { project_addons: @addons }, include: [:addon]
      end

      def show
        render json: { project_addon: @addon }, include: [:addon]
      end

      def create
        @sub = @project.addon_subscriptions.new(subscription_params)
        if @sub.save
          Projects::ProjectSyncService.new(@project).execute
          render json: { project_addon: @sub }
        else
          render json: { errors: @sub.errors.full_messages }, status: 400
        end
      end

      def update
        if @addon.update(update_params)
          Projects::ProjectSyncService.new(@project).execute unless cluster_request?
          render json: { project_addon: @addon }
        else
          render json: {
            errors: @addon.errors.full_messages
          }, status: 400
        end
      end

      def destroy
        @addon.destroy
        Projects::ProjectSyncService.new(@project).execute
        head :no_content
      end

      private

      def find_subscription
        @addon = @project.addon_subscriptions.find(params[:id])
      end

      def update_params
        params.require(:project_addon).permit(:overrides, :mappings, :status)
      end

      def subscription_params
        params.require(:project_addon).permit(:addon_id, :overrides, :name, :mappings)
      end
    end
  end
end
