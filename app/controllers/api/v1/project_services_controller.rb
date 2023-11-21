# frozen_string_literal: true

module Api
  module V1
    class ProjectServicesController < ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create destroy]

      before_action -> { :authorize_project_access }, only: %i[update]
      before_action :find_project
      before_action :find_subscription, only: %i[show update destroy]

      def create
        @sub = @project.service_subscriptions.build(service_params)
        if @sub.save
          render json: { service_subscription: @sub }
        else
          render json: { errors: @sub.errors.full_messages }, status: :bad_request
        end
      end

      def update
        if @sub.update(update_params)
          render json: { service_subscription: @sub }
        else
          render json: { errors: @sub.errors.full_messages }
        end
      end

      def destroy
        @service.destroy
        head :no_content
      end

      private

      def find_service
        @service = current_resource_owner.services.find(params[:id])
      end

      def find_subscription
        @sub = @project.service_subscriptions.find(params[:id])
      end

      def service_params
        params.require(:service_subscription).permit(:name, :service_id)
      end

      def update_params
        params.require(:service_subscription).permit(:status)
      end
    end
  end
end
