
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
        render json: @project, :include => [:addons]
      end

      def create
        @project = Project.new(project_params)
        @project.user = current_resource_owner
        @project.cluster = @clusters.sample
        if @project.save
          Projects::SyncProjectJob.perform_async(@project.id)
          render json: @project
        else
          puts @project.errors.inspect
          render json: {
            errors: @project.errors.full_messages
          }, status: 400
        end
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
        Projects::DeleteProjectJob.perform_async(@project.id)
        @project.update(status: "pending-deletion")
        head :no_content
      end

      private

      def find_project
        @project = Project.where(id: params[:id], user_id: current_resource_owner.id).first
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
