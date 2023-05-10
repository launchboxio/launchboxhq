module Projects
  class SyncProjectJob < ApplicationJob
    queue_as :default

    def perform(*args)
      timeout = 300

      @project = Project.find(args.first)
      @cluster = Cluster.find(@project.cluster_id)

      # We want to generate the configuration for our project
      payload = {}

      # Send our webhook
      client.publish(channel: "clusters:#{@cluster.id}", data: {
        :event => 'apply_manifest',
        :payload => payload.to_json
      }.to_json)

      # Monitor the deployment
      # For time until timeout, we want to check the project
      # to see if it's status has changed from "created".
    end
  end
end
