# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :cluster

    def connect
      self.cluster = authenticate!
    end

    protected

    def authenticate!
      reject_unauthorized_connection unless doorkeeper_token&.acceptable?(@_doorkeeper_scopes)

      # this will still allow expired tokens
      # you will need to check if token is valid with something like
      # doorkeeper_token&.acceptable?(@_doorkeeper_scopes)
      application_id = doorkeeper_token.application_id
      cluster = Cluster.find_by(oauth_application_id: application_id)

      cluster || reject_unauthorized_connection
    end

    def doorkeeper_token
      ::Doorkeeper.authenticate(request)
    end
  end
end
