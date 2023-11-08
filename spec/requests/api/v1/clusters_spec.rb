# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Clusters', type: :request do

  describe 'PATCH clusters/:id' do
    it 'updates a cluster status' do
      application = FactoryBot.create('doorkeeper/application')
      token = FactoryBot.create('doorkeeper/access_token', application:, scopes: 'manage_clusters')
      cluster = FactoryBot.create(:cluster, oauth_application_id: application.id)

      patch "/api/v1/clusters/#{cluster.id}", params: {
        cluster: {
          agent_version: '1.2.3',
          agent_identifier: 'pod-123/default',
          version: '1.25.15',
          provider: 'launchbox',
          region: 'us-east-1'
        }
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

  describe 'POST /clusters' do
    it 'requires admin' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create('doorkeeper/access_token', resource_owner_id: user.id, scopes: 'manage_clusters')
      post "/api/v1/clusters", params: {
        cluster: { }
      }, headers: {
        Authorization: "Bearer #{token.token}",
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'allows admins to create a cluster' do
      user = FactoryBot.create(:user, admin: true)
      token = FactoryBot.create('doorkeeper/access_token', resource_owner_id: user.id, scopes: 'manage_clusters')
      post "/api/v1/clusters", params: {
        cluster: {
          name: Faker::Alphanumeric.alpha(number: 10),
        }
      }, headers: {
        Authorization: "Bearer #{token.token}",
      }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /clusters' do
    it 'lists clusters' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create('doorkeeper/access_token', resource_owner_id: user.id, scopes: 'manage_clusters')
      FactoryBot.create_list(:cluster, 10)
      get '/api/v1/clusters', headers: {
        Authorization: "Bearer #{token.token}",
      }
      expect(response).to have_http_status(:success)
      expect(json['clusters'].size).to eq(10)
    end
  end

  describe 'GET /cluster' do
    it 'gets a clusters' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create('doorkeeper/access_token', resource_owner_id: user.id, scopes: 'manage_clusters')
      application = FactoryBot.create('doorkeeper/application')
      cluster = FactoryBot.create(:cluster, oauth_application_id: application.id)

      get "/api/v1/clusters/#{cluster.id}", headers: {
        Authorization: "Bearer #{token.token}",
      }
      expect(response).to have_http_status(:success)
      data = json['cluster']
      expect(data['name']).to eq(cluster.name)
      expect(data['oauth_application']).to be_nil
    end

    it 'adds credentials if admin' do
      admin = FactoryBot.create(:user, admin: true)
      token = FactoryBot.create('doorkeeper/access_token', resource_owner_id: admin.id, scopes: 'manage_clusters')
      application = FactoryBot.create('doorkeeper/application')
      cluster = FactoryBot.create(:cluster, oauth_application_id: application.id)

      get "/api/v1/clusters/#{cluster.id}", headers: {
        Authorization: "Bearer #{token.token}",
      }
      expect(response).to have_http_status(:success)
      data = json['cluster']
      expect(data['name']).to eq(cluster.name)
      expect(data['oauth_application']).not_to be_nil
    end
  end
end
