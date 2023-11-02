# frozen_string_literal: true

module Projects
  class ProjectCreateService < ProjectService
    def execute
      return false unless @project.save!

      @cluster = Cluster.find(@project.cluster_id)
      data = @project.as_json
      data['users'] = [
        { email: @project.user.email, clusterRole: 'cluster-admin' }
      ]
      ClusterChannel.broadcast_to(@cluster, { type: 'projects.created', id: SecureRandom.hex, payload: data })

      true
    end
  end
end
