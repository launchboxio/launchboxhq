# frozen_string_literal: true

module Projects
  class ProjectPauseService < ProjectService
    def execute
      @cluster = Cluster.find(@project.cluster_id)
      return false unless @project.update(status: :pausing)

      # Projects::PauseProjectJob.perform_async(@project.id)
      ClusterChannel.broadcast_to(@cluster, { type: 'projects.paused', id: SecureRandom.hex, payload: @project.as_json })
      true
    end
  end
end
