# frozen_string_literal: true

class ProjectsController < AuthenticatedController
  before_action :add_initial_breadcrumbs
  before_action :find_project, except: %i[index new create]

  include ActionController::Live

  def index
    @projects = Project.where(user_id: current_user.id)
  end

  def show; end

  def new
    @clusters = Cluster.all
    @addons = Addon.all
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    @project.cluster = Cluster.find(params[:project][:cluster])

    params[:addons]&.each do |addon, value|
      value == 'on' && (@project.addons << Addon.find(addon))
    end

    if @project.save
      @project.update(status: 'provisioning')
      SyncDeveloperProjectJob.perform_now(@project.id)
      redirect_to @project
    else
      flash[:alert] = @project.errors.full_messages
      redirect new_project_path
    end
  end

  def update; end

  def pause
    @project.update(status: 'pausing')
    PauseDeveloperProjectJob.perform_now(@project.id)
  end

  def resume
    @project.update(status: 'starting')
    ResumeDeveloperProjectJob.perform_now(@project.id)
  end

  def destroy
    @project.destroy
    Projects::DeleteProjectJob.perform_now(@project.slug, @project.cluster_id)
    redirect_to projects_path, notice: 'Project scheduled for deletion'
  end

  def restart; end

  def logs; end

  private

  def find_project
    @project = Project.where(id: params[:id], user_id: current_user.id)
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add 'Projects', projects_path
  end
end
