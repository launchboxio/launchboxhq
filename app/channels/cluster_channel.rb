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
    @project.ca_crt = data['ca_certificate']
    @project.save!
  end
end
