
class ClusterChannel < ApplicationCable::Channel
  def subscribed
    puts "Subscribing"
    reject unless cluster
    stream_for cluster
  end
end