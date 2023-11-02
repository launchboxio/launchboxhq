# frozen_string_literal: true

# AddonsChannel is a cluster scoped channel,
# which emits the following events to the
# reuired clusters
# - projects.created
# - projects.updated
# - projects.paused
# - projects.resumed
# - projects.deleted
# - addons.created
# - addons.updated
# - addons.deleted
class ClusterChannel < ApplicationCable::Channel
  def subscribed
    @cluster = Cluster.find(params[:cluster_id])
    stream_for @cluster
  end

  def ack; end

  def receive(data)
    puts data
  end

  def project_status(data)
    @project = Project.find(data['project_id'])
    @project.status = data['status']
    @project.ca_certificate = data['ca_certificate']
    @project.save!
  end

  # rubocop:disable Metrics/AbcSize
  def ping
    @cluster.agent_connected = true
    @cluster.agent_last_ping = DateTime.now
    @cluster.agent_version = data['version']
    @cluster.agent_identifier = data['identifier']
    @cluster.version = data['version']
    @cluster.provider = data['provider']
    @cluster.region = data['region']
    @cluster.save!
  end
  # rubocop:enable Metrics/AbcSize
end
