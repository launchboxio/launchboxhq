# frozen_string_literal: true

module Projects
  class ProjectDestroyService < ProjectService
    # We trigger the delete job for the project resources. Once
    # that job has completed, it will finalize and remove the
    # attached project
    def execute
      @cluster = Cluster.find(@project.cluster_id)
      ClusterChannel.broadcast_to(
        @cluster, {
          type: 'projects.deleted',
          id: SecureRandom.hex,
          payload: @project.id
        }
      )
      @project.update(status: :pending_deletion)
    end
  end
end
