# frozen_string_literal: true

module Api
  module V1
    class ProjectAddonsController < ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create update]
      before_action :find_project
      before_action :find_subscription, except: %i[index create]

      def index
        @addons = AddonSubscription.where(project_id: @project.id)
        render json: { addons: @addons }
      end

      def show
        @addon = AddonSubscription.find(params[:addon_id])
        render json: { addon: @addon }
      end

      def create
        @sub = @project.addon_subscriptions.new(subscription_params)
        if @sub.save
          Projects::ProjectSyncService.new(@project).execute
          render json: { addon: @sub }
        else
          render json: { errors: @sub.errors.full_messages }, status: 400
        end
      end

      def update; end

      def destroy
        @addon.destroy
        Projects::ProjectSyncService.new(@project).execute
        head :no_content
      end

      private

      def find_project
        @project = current_resource_owner.projects.find(params[:project_id])
      end

      def find_subscription
        @addon = @project.addon_subscriptions.find(params[:addon_id])
      end

      def subscription_params
        params.require(:project_addon).permit(:addon_id, :overrides, :name, :mappings)
      end
    end
  end
end
