# frozen_string_literal: true

module Projects
  class ServicesController < Projects::ApplicationController
    before_action :find_service, only: %i[show update]

    def show; end

    def new
      @services = current_user.services.all
      @service = @project.service_subscriptions.build
    end

    def create
      @sub = @project.service_subscriptions.build(service_params)
      if @sub.save
        redirect_to project_path(@project), notice: 'Service attached'
      else
        flash[:notice] = @sub.errors.full_messages.to_sentence
        render 'new'
      end
    end

    def destroy
      @subscription = @project.service_subscriptions.find(params[:id])
      @subscription.destroy
      redirect_to project_path(@project), notice: 'Service removed'
    end

    private

    def find_service
      @project.services.find(params[:id])
    end

    def service_params
      params.require(:service_subscription).permit(:name, :service_id)
    end
  end
end
