# frozen_string_literal: true

module Projects
  class ResumeProjectJob
    include Sidekiq::Job

    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)

      apps_client = @cluster.get_client("/apis/apps", 'v1')
      apps_client.patch_stateful_set(@project.slug, { spec: { replicas: 1 } }, @project.slug)

      @project.update(status: :running)
    end
  end
end