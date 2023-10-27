# frozen_string_literal: true

module Projects
  class DeleteProjectJob
    include Sidekiq::Job

    def perform(project_id)
      @project = Project.find(project_id)
      @project.update(status: :terminating)
      @cluster = Cluster.find(@project.cluster_id)
      client = @cluster.get_client('core.launchboxhq.io', 'v1alpha1')
      client.delete_project(@project.slug)
    end
  end
end
