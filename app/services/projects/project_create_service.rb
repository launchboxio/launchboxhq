# frozen_string_literal: true

module Projects
  class ProjectCreateService < ProjectService
    def execute
      @project.cluster = Cluster.where(status: 'active').sample if @project.cluster.nil?
      return false unless @project.save!

      @cluster = Cluster.find(@project.cluster_id)
      broadcast_event
      true
    end

    private

    def broadcast_event
      ClusterChannel.broadcast_to(
        @cluster,
        {
          type: 'projects.created',
          id: SecureRandom.hex,
          payload: build
        }
      )
    end
  end
end
