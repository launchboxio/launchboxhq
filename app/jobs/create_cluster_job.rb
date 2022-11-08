class CreateClusterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Connect to host cluster, and install cluster helm chart
    @cluster = Cluster.find(args.first)
    cli = Rhelm::Client.new(kubeconfig: '/home/rwittman/.kube/config')
    cli.install(
      @cluster.slug,
      '../../charts/cluster',
      values:
    )
  end
end
