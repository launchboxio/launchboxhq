# frozen_string_literal: true

class ClusterService
  attr_reader :cluster

  def initialize(cluster)
    @cluster = cluster
    super()
  end
end
