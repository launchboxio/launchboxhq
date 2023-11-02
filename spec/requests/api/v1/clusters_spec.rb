# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Clusters', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application: application, scopes: 'manage_clusters') }
  let(:cluster)     { FactoryBot.create(:cluster, oauth_application_id: application.id) }

  describe 'POST /ping' do
    it 'updates a cluster status' do
      post "/api/v1/clusters/#{cluster.id}/ping", params: {
        agent_version: '1.2.3',
        agent_identifier: 'pod-123/default',
        version: '1.25.15',
        provider: 'launchbox',
        region: 'us-east-1'
      }, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }

      res = Cluster.find(cluster.id)
      expect(res.version).to eql('1.25.15')
      expect(res.agent_version).to eql('1.2.3')
      expect(res.agent_identifier).to eql('pod-123/default')
      expect(res.provider).to eql('launchbox')
      expect(res.region).to eql('us-east-1')
    end
  end
end
