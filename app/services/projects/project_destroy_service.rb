# frozen_string_literal: true

module Projects
  class ProjectDestroyService < ProjectService
    # We trigger the delete job for the project resources. Once
    # that job has completed, it will finalize and remove the
    # attached project
    def execute
      ClusterChannel.broadcast_to(
        @project.cluster, {
          type: 'projects.deleted',
          id: SecureRandom.hex,
          payload: @project.id
        }
      )
      @project.update(status: :pending_deletion)
    end
  end
end
