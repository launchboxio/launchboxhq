# frozen_string_literal: true

module Projects
  class ProjectResumeService < ProjectService
    def execute
      return false unless @project.update(status: :starting)

      ClusterChannel.broadcast_to(
        @project.cluster, {
          type: 'projects.resumed',
          id: SecureRandom.hex,
          payload: @project.id
        }
      )
      true
    end
  end
end
