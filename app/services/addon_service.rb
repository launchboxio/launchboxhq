# frozen_string_literal: true

class AddonService
  attr_reader :addon

  def initialize(addon)
    @addon = addon
    super()
  end

  def broadcast_to_clusters(event)
    Cluster.all.each do |cluster|
      ClusterChannel.broadcast_to(
        cluster, {
          type: event,
          id: SecureRandom.hex,
          payload: @addon.as_json
        }
      )
    end
  end
end
