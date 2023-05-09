
module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      before_action -> { doorkeeper_authorize! :read_projects, :manage_projects }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_projects }, only: %i[create update destroy pause resume]
      before_action :find_project, except: %i[index new create]

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        render json: @project, :include => [:addons]
      end

      def create
        cluster = Cluster.find(params[:cluster_id])
        @project = current_resource_owner.projects.build(project_params)
        @project.cluster = cluster
        @project.save!
        Projects::CreateProjectJob.perform_later(@project.id)
        render json: @project
      end

      def pause
        @project.update(status: 'pausing')
        Projects::PauseProjectJob.perform_later(@project.id)
        render json: @project
      end

      def resume
        @project.update(status: 'starting')
        Projects::ResumeProjectJob.perform_later(@project.id)
        render json: @project
      end

      def destroy
        @project.destroy
        Projects::DeleteProjectJob.perform_later(@project.slug, @project.cluster_id)
        render json: @project
      end

      private

      def find_project
        @project = Project.where(id: params[:id], user_id: current_resource_owner.id).first
      end

      def project_params
        params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk)
      end
    end
  end
end
