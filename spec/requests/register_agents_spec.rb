# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Agent registration', type: :request do
  before { host! 'api.lvh.me' }
  let(:application)         { FactoryBot.create('doorkeeper/application') }
  let(:user)                { FactoryBot.create(:user) }
  let(:cluster)             { FactoryBot.create(:cluster) }
  let(:token)               { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'manage_clusters') }
  let(:invalid_agent_token) { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'agent') }

  describe 'POST /v1/clusters/{clusterId}/agents' do
    before do
      client_id = cluster.oauth_application.uid
      client_secret = cluster.oauth_application.secret
      post 'http://auth.lvh.me/oauth/token', params: {
        grant_type: 'client_credentials',
        client_id:,
        client_secret:,
        scope: 'agent'
      }
      post "http://api.lvh.me/v1/clusters/#{cluster.id}/agents", params: {
        agent: {
          pod_name: 'some-pod-1234',
          node_name: 'node1',
          ip_address: '127.0.0.1'
        }
      }, headers: {
        Authorization: "Bearer #{json['access_token']}",
        Accept: 'application/json'
      }
    end

    it 'registers an agent' do
      expect(response).to have_http_status(:success)
      expect(json['status']).to eql('registered')
    end
  end

  describe 'POST /v1/clusters/{clusterId}/agents fails with invalid application' do
    before do
      post "/v1/clusters/#{cluster.id}/agents", params: {
        agent: {
          pod_name: 'some-pod-1234',
          node_name: 'node1',
          ip_address: '127.0.0.1'
        }
      }, headers: {
        Authorization: "Bearer #{invalid_agent_token}",
        Accept: 'application/json'
      }
    end

    it 'returns 403' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
