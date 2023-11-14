# frozen_string_literal: true

module Projects
  class ProjectUpdateService < ProjectService
    def execute
      return false unless @project.save!

      ClusterChannel.broadcast_to(
        @project.cluster, {
          type: 'projects.created', id: SecureRandom.hex, payload: build
        }
      )
      true
    end
  end
end
