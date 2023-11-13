# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create destroy pause resume]

      before_action :find_project, except: %i[index new create]
      before_action :find_clusters, only: %i[create]

      before_action -> { :authorize_project_access }, only: %i[update]
      # before_action :authorize_project_read, only: %i[index show]
      # before_action :authorize_project_write, only: %i[create destroy pause resume]

      def index
        @projects = current_resource_owner.projects.all
        render json: { projects: @projects }
      end

      def show
        render json: { project: @project }, include: [:addons]
      end

      def create
        @project = Project.new(project_params)
        @project.user = current_resource_owner
        @project.cluster = Cluster.all.sample if @project.cluster.nil?

        if Projects::ProjectCreateService.new(@project).execute
          render json: { project: @project }
        else
          render json: {
            errors: @project.errors.full_messages
          }, status: 400
        end
      end

      def update
        if @project.update(update_params)
          render json: @project
        else
          render json: {
            errors: @project.errors.full_messages
          }, status: 400
        end
      end

      def pause
        if Projects::ProjectPauseService.new(@project).execute
          render json: { project: @project }
        else
          head :bad_request
        end
      end

      def resume
        if Projects::ProjectResumeService.new(@project).execute
          render json: { project: @project }
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

      def project_params
        params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk, :gpu, :kubernetes_version)
      end

      def update_params
        params.require(:project).permit(:status, :ca_certificate, :kubernetes_version)
      end

      def find_clusters
        @clusters = Cluster.all
      end

      def authorize_project_read
        doorkeeper_authorize! :read_projects, :manage_projects
      end

      def authorize_project_write
        authorize_project_access :manage_projects
      end
    end
  end
end
