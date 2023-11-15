# frozen_string_literal: true

class ProjectsController < AuthenticatedController
  # TODO: This allows any user with access to a project
  # to perform update / delete actions on it. We should
  # allow all with access to read the project data,
  # but only the creator should have destructive permissions
  before_action :find_project, except: %i[index new create]
  before_action :find_clusters

  def index
    @projects = current_user.projects.all
  end

  def new
    @project = Project.new
    @clusters = Cluster.where(status: 'active')
  end

  def show; end

  def create
    @project = current_user.projects.create(project_params)
    @project.user = current_user

    if Projects::ProjectCreateService.new(@project).execute
      redirect_to @project
    else
      flash[:notice] = @project.errors.full_messages
      render 'new'
    end
  end

  def destroy
    if Projects::ProjectDestroyService.new(@project).execute
      flash[:notice] = 'Project deleted'
      redirect_to projects_path
    else
      redirect_to @project
    end
  end

  def kubeconfig
    @application = Doorkeeper::Application.find_by(name: 'Cluster Authentication')
    @oidc_issuer = Rails.configuration.launchbox[:vcluster][:oidc_issuer_url]
    render 'kubeconfig', layout: false, content_type: 'application/x-yaml'
  end

  private

  def find_project
    @project = if current_user.admin?
                 Project.find(params[:id])
               else
                 current_user.projects.find(params[:id])
               end
  end

  def project_params
    params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk, :kubernetes_version)
  end

  def find_clusters
    @clusters = Cluster.all
  end
end
