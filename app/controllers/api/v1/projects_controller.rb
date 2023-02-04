
module Api
  module V1
    class ProjectsController < Api::V1::ApiController
      before_action :find_project, except: %i[index new create]

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        render json: @project
      end

      def create
        @project = current_user.projects.build(project_params)
        @project.cluster = Cluster.find(params[:project][:cluster])
        @project.save!
        render json: @project
      end

      def pause
        @project.update(status: 'pausing')
        Projects::PauseProjectJob.perform_now(@project.id)
      end

      def resume
        @project.update(status: 'starting')
        Projects::ResumeProjectJob.perform_now(@project.id)
      end

      def destroy
        @project.destroy
        Projects::DeleteProjectJob.perform_now(@project.slug, @project.cluster_id)
        redirect_to projects_path, notice: 'Project scheduled for deletion'
      end

      private

      def find_project
        @project = Project.where(id: params[:id], user_id: current_user.id)
      end

      def project_params
        params.require(:project).permit(:name)
      end
    end
  end
end
