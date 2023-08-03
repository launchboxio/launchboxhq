class ProjectsController < AuthenticatedController
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
    @project = Project.build(project_params)
    # Select a cluster at random
    @project.cluster = @clusters.sample
    if @project.save
      @project.users << current_user
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to @project
    else
      render 'new'
    end
  end

  def kubeconfig
    @application = Doorkeeper::Application.find_by(name: "oidc")
    @oidc_issuer = "https://launchboxhq.local"
    render 'kubeconfig', :layout => false, content_type: "application/x-yaml"
  end

  private
  def find_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:cluster_id, :name, :memory, :cpu, :disk)
  end

  def find_clusters
    @clusters = Cluster.all
  end
end
