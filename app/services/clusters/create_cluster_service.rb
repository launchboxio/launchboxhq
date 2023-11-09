# frozen_string_literal: true

module Clusters
  class CreateClusterService < ClusterService
    def execute
      @cluster.status = 'active' if @cluster.status.nil?
      application = Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: 'https://localhost:8080')
      @cluster.oauth_application = application
      @cluster.save!
      true
    end
  end
end
