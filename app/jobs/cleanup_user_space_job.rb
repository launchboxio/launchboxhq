class CleanupUserSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    slug = args.first
    cluster_id = args.second
    cluster = Cluster.find(cluster_id)

    @options = {
      auth_options:  { bearer_token: cluster.token },
      ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
    }

    # Get the version
    client = Kubeclient::Client.new(cluster.host, **@options)
    client.delete_namespace(slug)
  end
end
