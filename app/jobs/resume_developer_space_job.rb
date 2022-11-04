class ResumeDeveloperSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    space_id = args.first
    @space = Space.find(space_id)
    puts @space.slug

    auth_options = {
      bearer_token: @space.cluster.token
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }

    apps_client = Kubeclient::Client.new(
      "#{@space.cluster.host}/apis/apps", 'v1', auth_options: auth_options, ssl_options: ssl_options
    )
    # Resume the statefulset
    apps_client.patch_stateful_set(@space.slug, { spec: { replicas: 1 } }, @space.slug )
  end
end
