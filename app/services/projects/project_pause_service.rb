# frozen_string_literal: true

module Projects
  class ProjectPauseService < ProjectService
    def execute
      return false unless @project.update(status: :pausing)

      ClusterChannel.broadcast_to(
        @project.cluster, {
          type: 'projects.paused',
          id: SecureRandom.hex,
          payload: @project.id
        }
      )
      true
    end
  end
end
