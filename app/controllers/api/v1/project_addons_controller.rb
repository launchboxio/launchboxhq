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
        render json: @addons
      end

      def show
        @addon = AddonSubscription.find(params[:addon_id])
        render json: @addon
      end

      def create
        @project.inspect

        @project.addon_subscriptions.create(subscription_params)
        # @project.addons.new(subscription_params)
        @project.save!
      end

      def update; end

      def destroy
        @addon.destroy
      end

      private

      def find_project
        @project = Project.where(id: params[:project_id], user_id: current_resource_owner.id).first
      end

      def find_subscription
        @addon = AddonSubscription.find(params[:addon_id])
      end

      def subscription_params
        params.require(:project_addon).permit(:addon_id, :overrides, :name, :mappings)
      end
    end
  end
end
