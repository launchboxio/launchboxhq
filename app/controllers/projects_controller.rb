class ProjectsController < AuthenticatedController
  before_action :find_project, except: %i[index new create]
  before_action :find_clusters

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def show; end

  def create
    @project = current_user.projects.build(project_params)
    # Select a cluster at random
    @project.cluster = @clusters.sample
    puts @project.cluster.id
    if @project.save
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to @project
    else
      render 'new'
    end
  end

  def kubeconfig
    @oidc_issuer = "https://launchboxhq.local"
    @oidc_client_id = "abcd1234"
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
