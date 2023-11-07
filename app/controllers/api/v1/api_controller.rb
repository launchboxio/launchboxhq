# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
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
    end
  end
end
