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
  end

  def show; end

  def create
    @project = Project.new(project_params)
    @project.users = [current_user]
    @project.cluster = @clusters.sample
    if @project.save
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to @project
    else
      flash[:notice] = @project.errors.full_messages
      render 'new'
    end
  end

  def destroy
    Projects::DeleteProjectJob.perform_async(@project.id)
    @project.update(status: "pending-deletion")
    flash[:notice] = "Project deleted"
    redirect_to projects_path
  end

  def kubeconfig
    @application = Doorkeeper::Application.find_by(name: "oidc")
    @oidc_issuer = "https://launchboxhq.local"
    render 'kubeconfig', :layout => false, content_type: "application/x-yaml"
  end

  private
  def find_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk)
  end

  def find_clusters
    @clusters = Cluster.all
  end
end
