# frozen_string_literal: true

module Projects
  class ProjectUpdateService < ProjectService
    def execute
      return false unless @project.save!

      @cluster = Cluster.find(@project.cluster_id)
      ClusterChannel.broadcast_to(@cluster, { type: 'projects.updated', id: SecureRandom.hex, payload: @project.as_json })
      true
    end
  end
end
