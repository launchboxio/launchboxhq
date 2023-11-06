# frozen_string_literal: true

module Projects
  class ProjectCreateService < ProjectService
    def execute
      return false unless @project.save!

      @cluster = Cluster.find(@project.cluster_id)

      ClusterChannel.broadcast_to(
        @cluster, {
          type: 'projects.created', id: SecureRandom.hex, payload: build
        }
      )
      true
    end
  end
end
