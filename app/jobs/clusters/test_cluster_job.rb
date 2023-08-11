class Clusters::TestClusterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @cluster = Cluster.find(args.first)
    client = @cluster.get_client("/api", 'v1')
    pods = client.get_pods
    puts pods.inspect
  end
end
