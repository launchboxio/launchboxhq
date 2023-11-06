# frozen_string_literal: true

module Projects
  class ProjectUpdateService < ProjectService
    def execute
      return false unless @project.save!

      @cluster = Cluster.find(@project.cluster_id)
      payload = build(@project)
      ClusterChannel.broadcast_to(
        @cluster, {
          type: 'projects.created', id: SecureRandom.hex, payload:
        }
      )
      true
    end
  end
end
