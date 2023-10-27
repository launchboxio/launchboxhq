# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create update destroy pause resume]
      before_action :find_project, except: %i[index new create]
      before_action :find_clusters

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        render json: @project, include: [:addons]
      end

      def create
        @project = Project.new(project_params)
        @project.user = current_resource_owner
        @project.cluster = @clusters.sample if @project.cluster.nil?

        if Projects::ProjectCreateService.new(@project).execute
          render json: @project
        else
          render json: {
            errors: @project.errors.full_messages
          }, status: 400
        end
      end

      def pause
        if Projects::ProjectPauseService.new(@project).execute
          render json: @project
        else
          head :bad_request
        end
      end

      def resume
        if Projects::ProjectResumeService.new(@project).execute
          render json: @project
        else
          head :bad_request
        end
      end

      def destroy
        if Projects::ProjectDestroyService.new(@project).execute
          head :no_content
        else
          head :bad_request
        end
      end

      private

      def find_project
        @project = Project.where(id: params[:id], user_id: current_resource_owner.id).first
        render status: 404 if @project.nil?
      end

      def project_params
        params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk, :gpu)
      end

      def find_clusters
        @clusters = Cluster.all
      end
    end
  end
end
