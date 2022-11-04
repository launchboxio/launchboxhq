class PauseDeveloperSpaceJob < ApplicationJob
  queue_as :default

  # https://github.com/loft-sh/vcluster/blob/main/cmd/vclusterctl/cmd/pause.go
  def perform(*args)
    # Do something later
    space_id = args.first
    @space = Space.find(space_id)
    puts @space.slug

    auth_options = {
      bearer_token: @space.cluster.token
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }

    client = Kubeclient::Client.new(
      @space.cluster.host, 'v1', auth_options: auth_options, ssl_options: ssl_options
    )
    apps_client = Kubeclient::Client.new(
      "#{@space.cluster.host}/apis/apps", 'v1', auth_options: auth_options, ssl_options: ssl_options
    )

    # Suspend the statefulset
    apps_client.patch_stateful_set(@space.slug, { spec: { replicas: 0 } }, @space.slug )

    # Delete created workloads
    pods = client.get_pods(namespace: @space.slug, label_selector: "vcluster.loft.sh/managed-by=#{@space.slug}")
    pods.each do |pod|
      client.delete_pod(pod.name, @space.slug)
    end
  end
end
