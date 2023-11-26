# frozen_string_literal: true

module Api
  module V1
    class ServicesController < ApiController
      before_action -> { doorkeeper_authorize! :manage_services, :read_services }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_services }, only: %i[create update destroy]

      before_action :find_service, only: %i[show update destroy]

      def index
        if params[:repository_id].nil?
          render json: { services: current_resource_owner.services }
        else
          @repository = current_resource_owner.repositories.find(params[:repository_id])
          render json: { services: @repository.services }
        end
      end

      def show
        render json: { service: @service }
      end

      def create
        @service = @repository.services.new(service_params)
        if @service.save
          render json: { service: @service }
        else
          render json: { errors: @service.errors.full_messages }, status: :bad_request
        end
      end

      def update
        if @service.update(update_params)
          render json: { service: @service }
        else
          render json: { errors: @service.errors.full_messages }, status: :bad_request
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

      def service_params
        params.require(:service).permit(:name, :deployment_strategy, :update_strategy)
      end

      def update_params
        params.require(:service).permit(:name, :deployment_strategy, :update_strategy)
      end
    end
  end
end
