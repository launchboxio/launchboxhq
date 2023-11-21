# frozen_string_literal: true

module Api
  module V1
    class ServicesController < ApiController
      before_action -> { doorkeeper_authorize! :manage_services, :read_services }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_services }, only: %i[create update destroy]

      before_action :find_service, only: %i[show update destroy]

      def index
        render json: { services: current_resource_owner.services }
      end

      def show
        render json: { service: @service }
      end

      def create
        @service = current_resource_owner.services.new(service_params)
        if Services::CreateService.new(@service).execute
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
        params.require(:service).permit(:vcs_connection_id, :full_name, :name)
      end

      def update_params
        params.require(:service).permit(:name)
      end
    end
  end
end
