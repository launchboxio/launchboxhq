# frozen_string_literal: true

module Projects
  class PauseProjectJob
    include Sidekiq::Job

    # https://github.com/loft-sh/vcluster/blob/main/cmd/vclusterctl/cmd/pause.go
    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      client = @cluster.get_client('core.launchboxhq.io', 'v1alpha1')
      client.patch_project(@project.slug, { spec: { paused: true } })
    end
  end
end
