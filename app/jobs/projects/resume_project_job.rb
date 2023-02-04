# frozen_string_literal: true

module Projects
  class ResumeProjectJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Do something later
      project_id = args.first
      @project = Project.find(project_id)
      @options = {
        auth_options: { bearer_token: @project.cluster.token },
        ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
      }

      apps_client = Kubeclient::Client.new("#{@project.cluster.host}/apis/apps", 'v1', **options)
      apps_client.patch_stateful_set(@project.slug, { spec: { replicas: 1 } }, @project.slug)

      @project.update(status: 'started')
    end
  end
end