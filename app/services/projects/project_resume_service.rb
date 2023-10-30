# frozen_string_literal: true

module Projects
  class ProjectResumeService < ProjectService
    def execute
      @cluster = Cluster.find(@project.cluster_id)
      return false unless @project.update(status: :starting)

      ClusterChannel.broadcast_to(@cluster, { type: 'projects.resumed', id: SecureRandom.hex, payload: @project.as_json })
      true
    end
  end
end
