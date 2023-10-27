# frozen_string_literal: true

module Clusters
  class ImportClusterConfigurationJob < ApplicationJob
    queue_as :default

    def perform(*args)
      @cluster = Cluster.find(args.first)
      @options = {
        auth_options: { bearer_token: @cluster.token },
        ssl_options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
      }

      conn = Faraday.new(
        url: @cluster.host,
        params: { param: '1' },
        headers: { 'Authorization' => "Bearer #{@cluster.token}" },
        ssl: { verify: false }
      ) do |f|
        f.response :json
      end

      response = conn.get('/version')
      body = response.body

      # Get region, provider, things like that :shrug:
      @cluster.version = "#{body['major']}.#{body['minor']}"
      @cluster.save
    end
  end
end
