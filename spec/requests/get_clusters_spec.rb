require 'rails_helper'

RSpec.describe 'Get Clusters', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'read_clusters') }

  describe 'GET /index' do
    before do
      FactoryBot.create_list(:cluster, 10)
      get '/api/v1/clusters' , params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns all clusters' do
      expect(json.size).to eq(10)
      expect(response).to have_http_status(:success)
    end

  end

  describe 'GET /{clusterId}' do
    before do
      FactoryBot.create_list(:cluster, 2)
      cluster = Cluster.first
      get "/api/v1/clusters/#{cluster.id}" , params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns expected cluster' do
      cluster = Cluster.first
      expect(json['id']).to eq(cluster.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /clusters without authentication' do
    before do
      get "/api/v1/clusters" , params: {}, headers: {
        Accept: 'application/json'
      }
    end

    it 'returns 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

