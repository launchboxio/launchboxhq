# frozen_string_literal: true

module Api
  module V1
    class RepositoriesController < ApiController
      before_action -> { doorkeeper_authorize! :manage_repositories, :read_repositories }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_repositories }, only: %i[create update destroy]

      def index
        render json: {
          repositories: current_resource_owner.repositories
        }
      end

      def show
        render json: {
          repository: @repository
        }
      end

      def create
        @repository = current_resource_owner.new(repository_params)
        if Repositories::CreateRepositoryService.new(@repository).execute
          render json: {
            repository: @repository
          }
        else
          render json: {
            errors: @repository.errors.full_messages
          }, status: :bad_request
        end
      end

      def update
        if @repository.update(update_params)
          render json: { repository: @repository }
        else
          render json: {
            repository: @repository.errors.full_messages
          }, status: :no_content
        end
      end

      def destroy
        @repository.destroy
        head :no_content
      end

      private

      def repository_params
        params.require(:repository).permit(:vcs_connection_id, :repository)
      end

      def find_repository
        @repository = current_resource_owner.repositories.find(params[:id])
      end
    end
  end
end
