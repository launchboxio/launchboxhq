# frozen_string_literal: true

module Clusters
  class CreateClusterJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Connect to ClusterAPI environment, and install cluster helm chart
      # The helm chart will install ClusterAPI resources depending on the
      # various configs required for the environment
      @cluster = Cluster.find(args.first)
      cli = Rhelm::Client.new(kubeconfig: '/home/rwittman/.kube/config')
      cli.install(
        @cluster.slug,
        '../../charts/cluster'
        # values:
      )

      # Once the cluster resources have been created, we want to poll
      # the CRD to get the various required information out of it
    end
  end
end
