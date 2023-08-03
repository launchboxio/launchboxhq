# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      reject unless cluster
      stream_for cluster
    end
  end
end
