# frozen_string_literal: true

class ResumeDeveloperSpaceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    space_id = args.first
    @space = Space.find(space_id)
    @options = {
      auth_options: { bearer_token: @space.cluster.token },
      ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
    }

    apps_client = Kubeclient::Client.new("#{@space.cluster.host}/apis/apps", 'v1', **options)
    apps_client.patch_stateful_set(@space.slug, { spec: { replicas: 1 } }, @space.slug)

    @space.update(status: 'started')
  end
end
