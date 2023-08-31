module Api
  module V1
    module Projects
      class SecretsController < Api::V1::ApiController
        def create
          @project = Project.find(params[:project_id])
          @subscription = @project.addon_subscriptions.find(params[:id])
          @subscription.connection_secret = params[:secret]
          @subscription.save
          @subscription
        end
      end
    end
  end
end
