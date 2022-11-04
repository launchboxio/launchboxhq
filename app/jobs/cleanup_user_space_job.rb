class CleanupUserSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    slug = args.first
    cluster_id = args.second

    cluster = Cluster.find(cluster_id)

    auth_options = {
      bearer_token: cluster.token
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
    # Ensure the namespace exists
    client = Kubeclient::Client.new(
      cluster.host, 'v1', auth_options: auth_options, ssl_options: ssl_options
    )

    client.delete_namespace(slug)
  end
end
