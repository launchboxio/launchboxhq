# frozen_string_literal: true

class ClusterChannel < ApplicationCable::Channel
  def subscribed
    reject unless cluster
    stream_for cluster
  end
end
