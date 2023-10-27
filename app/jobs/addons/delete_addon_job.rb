# frozen_string_literal: true

module Addons
  class DeleteAddonJob
    include Sidekiq::Job
    queue_as :default

    # rubocop:disable Metrics/AbcSize
    def perform(*args)
      @subscription = AddonSubscription.find(args.first)
      @project = @subscription.project
      @cluster = Cluster.find(@project.cluster_id)
      version = @subscription.addon.addon_versions.first
      action = version.claim_name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .downcase
      client = @cluster.get_client("/apis/#{version.group}", version.version)
      client.public_send("delete_#{action}", @subscription.name, @project.slug)
      @subscription.destroy
    end
    # rubocop:enable Metrics/AbcSize
  end
end
