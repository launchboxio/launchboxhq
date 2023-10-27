# frozen_string_literal: true

module Projects
  class ResumeProjectJob
    include Sidekiq::Job

    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)

      client = @cluster.get_client('core.launchboxhq.io', 'v1alpha1')
      client.patch_project(@project.slug, { spec: { paused: false } })

      @project.update(status: :running)
    end
  end
end
