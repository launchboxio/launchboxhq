module Projects
  class DeploymentsController < Projects::ApplicationController
    before_action :find_deployment, only: %i[show edit update destroy]

    def index
      @deployments = @project.deployments
    end

    def show; end
    def edit; end

    def new
      @resources = current_user.resources
      @deployment = @project.deployments.build
    end

    def update; end
    def create
      @attachment = @project.deployments.build(deployments_params)
      if @attachment.save
        Projects::SyncProjectJob.perform_async @project.id
        redirect_to project_path(@project), notice: 'Service attached'
      else
        flash[:notice] = @sub.errors.full_messages.to_sentence
        render 'new'
      end
    end

    def destroy
      Deployments::UninstallJob.perform_async @deployment.id
      flash[:notice] = 'Service pending removal'
      redirect_to project_path(@project)
    end

    private
    def find_deployment
      @deployment = @project.deployments.find(params[:id])
    end

    def deployments_params
      params.require(:deployment).permit(:name, :ref, :resource_id)
    end
  end
end
