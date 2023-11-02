# frozen_string_literal: true

module Projects
  class ProjectUpdateService < ProjectService
    def execute
      return false unless @project.save!

      # @cluster = Cluster.find(@project.cluster_id)
      # ClusterChannel.broadcast_to(@cluster, { type: 'projects.updated', id: SecureRandom.hex, payload: @project.as_json })
      data = @project.as_json
      data['users'] = [
        { email: @project.user.email, clusterRole: 'cluster-admin' }
      ]

      Rails.configuration.event_store.publish(Events::ProjectCreated.new(data: ))
      true
    end
  end
end
