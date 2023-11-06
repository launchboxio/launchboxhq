# frozen_string_literal: true

module Projects
  class ProjectPauseService < ProjectService
    def execute
      @cluster = Cluster.find(@project.cluster_id)
      return false unless @project.update(status: :pausing)

      ClusterChannel.broadcast_to(
        @cluster, {
          type: 'projects.paused',
          id: SecureRandom.hex,
          payload: @project.id
        }
      )
      true
    end
  end
end
