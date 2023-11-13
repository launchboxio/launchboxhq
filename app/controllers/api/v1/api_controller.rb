# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      rescue_from RuntimeError do |ex|
        render json: { success: false, error: ex.class.name, message: ex.message }, status: 500
      end

      private

      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def require_admin!
        head :forbidden unless current_resource_owner.admin?
      end

      def cluster_request?
        !doorkeeper_token.application_id.nil?
      end

      def authorize_project_access(*scopes)
        doorkeeper_token = ::Doorkeeper.authenticate(request)
        head :unauthorized and return if doorkeeper_token.nil?

        if cluster_request?
          cluster = Cluster.where(oauth_application_id: doorkeeper_token.application_id).first
          head :forbidden if cluster.nil? || (cluster.id != @project.cluster_id)
        else
          doorkeeper_authorize! scopes
        end
      end

      def find_project
        @project = if cluster_request?
                     Project.find(params[:project_id])
                   else
                     current_resource_owner.projects.where(id: params[:project_id]).first
                   end
        render status: 404 if @project.nil?
      end
    end
  end
end
