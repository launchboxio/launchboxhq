# frozen_string_literal: true

module Clusters
  class SyncClustersJob
    include Sidekiq::Job

    def perform(*_args)
      @clusters = Cluster.all
      @addons = Addon.all
      @addons.each do |addon|
        @clusters.each do |cluster|
          ClusterChannel.broadcast_to(cluster, { type: 'addons.updated', id: SecureRandom.hex, payload: addon.as_json })
        end
      end
    end
  end
end
