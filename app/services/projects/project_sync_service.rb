# frozen_string_literal: true

module Projects
  class ProjectSyncService < ProjectService
    def execute
      ClusterChannel.broadcast_to(
        @project.cluster,
        {
          type: 'projects.updated',
          id: SecureRandom.hex,
          payload: build
        }
      )
    end
  end
end
